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
            let t: [String] = String.regex(pattern: "<u-highlight-fts>[\\S]*", target: k.body_h)
            if t.count > 0 {
                //TODO: 如果文档长度小, 组合多个结果
                topic["body_hp"] = t[0]
            } else {
                topic["body_hp"] = k.body_h
            }
            return topic
        }
    }
    
    //MARK: - 话题添加
    func add(title: String, body: String) throws {
        let statement = _sql_topic_add
        let params: [Any] = [title, body]
        try sql_ex(statement, params: params)
    }
}
