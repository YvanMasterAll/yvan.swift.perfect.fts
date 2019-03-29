// swift-tools-version:4.0
// Generated automatically by Perfect Assistant
// Date: 2019-02-21 04:02:35 +0000

import PackageDescription

let package = Package(
	name: "FtsServer",
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/Perfect-RequestLogger.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/iamjono/JSONConfig.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/SwiftORM/Postgres-StORM.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-PostgreSQL.git", "3.0.0"..<"4.0.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", from: "3.0.2")
	],
	targets: [
		.target(name: "App", dependencies: [
			"PerfectRequestLogger", 	//请求日志
			"JSONConfig", 				//文件解析
			"PerfectHTTPServer",		//HTTP服务
			"PostgresStORM", 			//PostgreSQL ORM
			"PerfectPostgreSQL",		//PostgreSQL Provider
			"PerfectMustache",			//模板引擎
			]),
        .target(
            name: "Run",
            dependencies: ["App"]),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"])
	]
)

