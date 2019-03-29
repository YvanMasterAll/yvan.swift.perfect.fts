import XCTest
import class Foundation.Bundle
import App
import PerfectLib

final class AppTests: BaseTestCase {
    
    //MARK: - IO测试
    func test_IO() {
        let path = "./data"
        test_IO_001(path: path)
        print("2")
    }
    func test_IO_001(path: String) {
        let dir = Dir.init(path)
        do {
            var entries: [String] = []
            try dir.forEachEntry(closure: { d in
                if !d.startsWith(".") {
                    entries.append("\(dir.path)\(d)")
                }
            })
            entries.forEach { entry in
                if File(entry).isDir {
                    test_IO_001(path: entry)
                } else {
                    print(entry)
                }
            }
        } catch {
            print(error)
        }
    }
    
    //MARK: - 全文检索测试, 过滤搜索结果, 选取片段
    func test_Fts_FilterResult() {
        let body_h: String = """
天气<u-highlight-fts>天</u-highlight-fts>气转暖，
春风<u-highlight-fts>春</u-highlight-fts>风和煦天气<u-highlight-fts>天</u-highlight-fts>气转暖，
春风<u-highlight-fts>春</u-highlight-fts>风和煦天气<u-highlight-fts>天</u-highlight-fts>气转暖，春风<u-highlight-fts>春</u-highlight-fts>风和煦天气<u-highlight-fts>天</u-highlight-fts>气
转暖，春风<u-highlight-fts>春</u-highlight-fts>风和煦
"""
        let results = String.regex(pattern: "<u-highlight-fts>[\\S]*", target: body_h)
        print(results[0])
    }
    
    //MARK: - 测试网络
    func test_Network() {
        let timeout = 5 as TimeInterval
        let ept = expectation(description: "")
        //let url = "https://www.baidu.com/"
        let url = "http://192.168.1.3:8181/api/v1/getpassword"
        CurlHelper.instance.request(url: url,
                                    method: .post,
                                    cookie: nil,
                                    fields: [.init(name: "name", filePath: "yvan")],
                                    completion: { (data, success, error, code) in
                                        print("请求结果: \(success)")
                                        print("响应代码: \(code)")
                                        if let _ = data { print("请求数据: \(data!)") }
                                        if let _ = error { print("错误信息: \(error!)") }
                                        XCTAssertEqual(code, 200)
                                        ept.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }
        
        let fooBinary = productsDirectory.appendingPathComponent("App")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Hello, world!\n")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
