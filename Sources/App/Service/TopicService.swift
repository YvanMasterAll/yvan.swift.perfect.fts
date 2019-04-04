//
//  TopicService.swift
//  App
//
//  Created by Yiqiang Zeng on 2019/3/29.
//

import Foundation
import PerfectLib
import StORM

protocol TopicService: class {
    
    var topicModel: TopicModel { get }
    
    //MARK: - 话题搜索
    func search(kw: String, cursor: StORMCursor) throws -> [[String: Any]]
    
    //MARK: - 结果数量
    func search(kw: String) throws -> Int
}
