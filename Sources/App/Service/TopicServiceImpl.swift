//
//  TopicServiceImpl.swift
//  App
//
//  Created by Yiqiang Zeng on 2019/3/29.
//

import Foundation
import PerfectLib
import StORM

class TopicServiceImpl: TopicService {
    
    lazy var topicModel: TopicModel = {
        return TopicModel()
    }()
    
    /// 话题搜索
    ///
    /// - Parameters:
    ///   - kw: 关键字
    ///   - cursor: 查询游标
    /// - Returns: 返回结果
    func search(kw: String, cursor: StORMCursor) throws -> [[String : Any]] {
        return try topicModel.search(kw: kw, cursor: cursor)
    }
}

