//
//  TopicController.swift
//  App
//
//  Created by Yiqiang Zeng on 2019/3/29.
//

import Foundation

class TopicController : BaseController {
    
    //MARK: - 声明区域
    lazy var topicService: TopicService = {
        return TopicServiceImpl()
    }()
    
    override init() {
        super.init()
        
        //MARK: - 路由
        self.route.add(method: .post, uri: "\(baseRoute)/topic/search", handler: self.search())
    }
}

extension TopicController {
    
    //MARK: - 话题搜索
    public func search() -> RequestHandler {
        return { request, response in
            guard let kw = request.param(name: "kw") else {
                response.callback(ResultSet.requestIllegal)
                return
            }
            var count = request.param(name: "count")?.toInt()
            do {
                if count == nil {
                    count = try self.topicService.search(kw: kw)
                    response.callback(Result(code: .success, count: count!))
                    return
                }
                let list = try self.topicService.search(kw: kw, cursor: request.cursor())
                response.callback(Result(code: .success, data: list))
            } catch {
                print(error)
                response.callback(ResultSet.serverError)
            }
        }
    }
}
