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
            let ps = headline(ws: ws, body: k.body)
            topic["body_hp"] = ps
            return topic
        }
    }
    
    //MARK: - 关键字高亮
    func headline(ws: [String], body: String) -> String {
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
        return ps
    }
    
    //MARK: - 话题添加
    func add(title: String, body: String) throws {
        let statement = _sql_topic_add
        let params: [Any] = [title, body]
        try sql_ex(statement, params: params)
    }
}
