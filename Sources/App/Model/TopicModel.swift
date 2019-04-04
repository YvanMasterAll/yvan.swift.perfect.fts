//
//  TopicModel.swift
//  App
//
//  Created by Yiqiang Zeng on 2019/3/29.
//

import Foundation
import StORM
import PostgresStORM
import PerfectLib
import SwiftString

class TopicModel: BaseModel {
    
    //MARK: - 声明区域
    var id              : Int           = 0
    var title           : String        = ""
    var body            : String        = ""
    var rank            : Float         = 0
    var query           : String        = ""
    var body_h          : String        = ""
    
    override open func table() -> String {  return "fts_topic"  }
    
    override func columns() -> [String]? {
        return ["id",
            "title",
            "body"
        ]
    }
    
    //MARK: - 表映射
    override public func to(_ this: StORMRow) {
        super.to(this)
        if let v = this.data["id"]      as? Int     { id     = v }
        if let v = this.data["title"]   as? String  { title  = v }
        if let v = this.data["body"]    as? String  { body   = v }
        if let v = this.data["rank"]    as? Float   { rank   = v }
        if let v = this.data["query"]   as? String  { query  = v }
        if let v = this.data["body_h"]  as? String  { body_h = v }
    }
    public func rows() -> [TopicModel] {
        return self._rows(model: self)
    }
    
    //MARK: - 私有成员
    fileprivate let _tsv = "tsv"    //检索字段, tsvector
    fileprivate let _body = "body"  //文档字段
    fileprivate let _sql_topic_add = """
insert into fts_topic(title, body) values($1, $2)
"""
}

extension TopicModel {
    
    //MARK: - 话题搜索
    func search(kw: String, cursor: StORMCursor) throws -> [[String: Any]] {
        try fts_find(tsv: _tsv, kw: kw, body: _body, cursor: cursor)
        return rows().map() { k in
            var topic = k.toDict()
            //TODO: 如果文档长度小, 直接返回
            let ws = k.query.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "'", with: "")
                .split("&")
            let (ps, ts) = headline(ws: ws, body: k.body, title: k.title)
            topic["body_hp"] = ps
            topic["title"] = ts
            return topic
        }
    }
    func search(kw: String) throws -> Int {
        return try fts_count(tsv: _tsv, kw: kw)
    }
    
    //MARK: - 关键字高亮
    func headline(ws: [String], body: String, title: String) -> (String, String) {
        var ps = ""
        let _ps = body.split("\n")
        var pc = 0
        for p in _ps {
            pc += pc
            for w in ws {
                if p.lowercased().contains(string: w) {
                    let _p = p.replacingOccurrences(of: w, with: "<u-highlight-fts>\(w)</u-highlight-fts>", options: .caseInsensitive)
                    ps.append(_p + "...")
                    break
                }
            }
            if ps.count > 200 { break }
        }
        var ts = title
        var ws_c = 0
        var ws_d: [Int: [String]] = [:]
        ws.forEach { w in
            let c = w.count
            if ws_d[c] == nil { ws_d[c] = [w] } else { ws_d[c]?.append(w) }
            ws_c = ws_c > c ? ws_c:c
        }
        let ws_t = ws_d[ws_c]
        ws_t?.forEach { w in
            ts = ts.replacingOccurrences(of: w, with: "<u-highlight-fts>\(w)</u-highlight-fts>", options: .caseInsensitive)
        }
        return (ps, ts)
    }
    
    //MARK: - 话题添加
    func add(title: String, body: String) throws {
        let statement = _sql_topic_add
        let params: [Any] = [title, body]
        try sql_ex(statement, params: params)
    }
}
