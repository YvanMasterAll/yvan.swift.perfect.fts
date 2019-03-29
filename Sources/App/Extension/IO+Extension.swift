//
//  IO+Extension.swift
//  App
//
//  Created by Yiqiang Zeng on 2019/3/29.
//

import PerfectLib

extension Dir {
    
    /// 遍历目录
    ///
    /// - Parameter path: 目录
    /// - Returns: 返回所有文件目录
    static func dirs(path: String) -> [String] {
        let dir = Dir.init(path)
        var drs: [String] = []
        do {
            var entries: [String] = []
            try dir.forEachEntry(closure: { entry in
                if !entry.startsWith(".") {
                    entries.append("\(dir.path)\(entry)")
                }
            })
            entries.forEach { entry in
                if File(entry).isDir {
                    drs.append(contentsOf: dirs(path: entry))
                } else {
                    drs.append(entry)
                }
            }
        } catch {
            print(error)
        }
        return drs
    }
}

extension File {
    
    /// 读取文件
    ///
    /// - Parameter path: 文件目录
    /// - Returns: 返回Txt
    static func readfile(path: String) throws -> String {
        let file = File(path)
        defer { file.close() }
        try file.open(.read, permissions: .readUser)
        return try file.readString()
    }
}
