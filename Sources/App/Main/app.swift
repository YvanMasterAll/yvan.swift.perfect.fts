//
//  app.swift
//  FtsServerPackageDescription
//
//  Created by yiqiang on 2018/1/20.
//

import PerfectLib
import StORM
import PerfectHTTPServer
import PostgresStORM
import PerfectRequestLogger

public func app() -> HTTPServer {
	//MARK: - 创建服务
	let server = HTTPServer()

	//MARK: - 请求日志
	RequestLogFile.location = baseLog

	//MARK: - 查询日志
	StORMdebug = true

	//MARK: - 环境初始化
	Environment.initialize()

	//MARK: - 路由初始化
	server.addRoutes(initializeRoute())

	//MARK: - 过滤器初始化
	server.setRequestFilters(baseRequestFilter())
	server.setResponseFilters(baseResponseFilter())

	//MARK: - 测试初始化
	TestUtil.setup()

	//MARK: - 启动服务
	server.serverPort = UInt16(baseServerPort)
	server.documentRoot = baseDocument
	
	return server
}
