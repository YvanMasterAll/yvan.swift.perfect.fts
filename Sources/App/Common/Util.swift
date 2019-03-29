//
//  Util.swift
//  FtsServerPackageDescription
//
//  Created by yiqiang on 2018/1/20.
//

import JSONConfig
import Foundation
import PerfectLib
import PostgresStORM
#if os(Linux) || os(Android) || os(FreeBSD)
import Glibc
#else
import Darwin
#endif

struct Util {
    
    /// 生成随机数
    /// - parameter min: 最小值, 包含最小值
    /// - parameter max: 最大值, 包含最大值
    static func randomNumber(min: Int, max: Int) -> Int {
        #if os(Linux)
        return Int((random() % (max - min + 1)) + min)
        #else
        return Int(arc4random_uniform(UInt32(max - min + 1)) + UInt32(min))
        #endif
    }
    
    //MARK: - 文件操作
    
    /// 解析Json文件为字典
    ///
    /// - Parameter filePath: 文件路径
    static func fileToDict(filePath: String) -> [String: Any]? {
        if let data = JSONConfig(name: filePath) {
            return data.getValues()
        }
        return nil
    }
}

//MARK: - 测试工具
import StORM
struct TestUtil {
    
    public static func setup() {
        //self.test_RandomNumber()
        //self.test_Fts_TestData()
    }
    
    //MAKR: - 测试随机数生成
    fileprivate static func test_RandomNumber() {
        for _ in 0..<10 {
            print(Util.randomNumber(min: 10, max: 20))
        }
    }
    
    //MARK: - 全文检索测试, 将德哥的博客作为测试数据保存到数据库
    //https://github.com/digoal/blog/blob
    fileprivate static func test_Fts_TestData() {
        let path = "./data"                                 //数据目录
        let dirs = Dir.dirs(path: path)                     //遍历文件夹
        let topic = TopicModel()
        do {
            var data: [(String, String)] = []
            try dirs.forEach { dir in                       //读取文件
                let body = try File.readfile(path: dir)
                var title = ""
                if let index = body.firstIndex(of: "\n") {  //获取标题
                    title = String(body[body.startIndex..<index])
                }
                data.append((title, body))
            }
            try PostgresStORM.doWithTransaction(closure: {      //数据存储
                try data.forEach { d in
                    try topic.add(title: d.0, body: d.1)
                }
            })
        } catch {
            
        }
    }
}

//MARK: - 类型工具
public class TypeUtil {
    
    /// 判断枚举类型并返回枚举值, 判断日期类型, 返回日期值, [yyyy-MM-dd hh:mm:ss]
    ///
    /// - Parameter value: 传入对象
    /// - Returns: 若传入对象非类型, 返回自身
    public static func value(_ type: Any) -> Any {
        switch type {
        case let kType as BaseType     : return kType.value
        case let kType as Date         : return Date.toString(date: kType)
        default                        : return type
        }
    }
}
