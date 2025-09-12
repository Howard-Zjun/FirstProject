//
//  PathSetManager.swift
//  FirstProject
//
//  Created by Zack-Zeng on 2025/9/11.
//

import UIKit
import SwiftSVG

class PathSetManager: NSObject {

    var parseFinishURLMap: [URL : UIBezierPath] = [:]
    
    var pointSet: Set<String> = []
    
    var relationMap: [String : PointRelation] = [:]
    
    var handleParser: [XMLParser : ParseDataModel] = [:]
    
    func setSinglePathFrom(fromName: String, toName: String, toSVG: URL) {
        pointSet.insert(fromName)
        pointSet.insert(toName)
        var relation: PointRelation?
        if let tmp = relationMap[fromName] {
            relation = tmp
        } else {
            relation = .init(pointName: fromName)
        }
        
        relation?.toPointArr.append((toName, toSVG))
        relationMap[fromName] = relation
    }
    
    func getPath(fromName: String, toName: String, completion: @escaping (UIBezierPath?, PathError?) -> Void) {
        print("[\(String(describing: Self.self))-\(#function)-\(Thread.current):\(#line)] 获取\(fromName)到\(toName)的路径")
        do {
            let urls: [URL] = try getPathURL(fromName: fromName, toName: toName)
            parseURL(urls: urls, completion: completion)
        } catch {
            print("[\(String(describing: Self.self))-\(#function)-\(Thread.current):\(#line)] 错误: \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
    private func getPathURL(fromName: String, toName: String) throws(PathError) -> [URL] {
        guard pointSet.contains(fromName) else {
            throw .unExistFromPoint
        }
        
        guard pointSet.contains(toName) else {
            throw .unExistToPoint
        }
        
        // 使用广度优先搜索(BFS)寻找最短路径
        var queue: [(currentPoint: String, path: [URL])] = [(fromName, [])]
        var visited: Set<String> = [fromName]
        
        while !queue.isEmpty {
            let (current, currentPath) = queue.removeFirst()
            
            // 遍历当前点可达的所有点
            guard let relations = relationMap[current] else {
                continue
            }
            
            for (nextPoint, pathURL) in relations.toPointArr {
                if nextPoint == toName {
                    // 找到终点，返回完整路径
                    let ret = currentPath + [pathURL]
                    print("[\(String(describing: Self.self))-\(#function)-\(Thread.current):\(#line)] 从\(fromName)到\(toName)的路径是\(ret.map({ $0.lastPathComponent }))")
                    return ret
                }
                
                // 未访问过的点加入队列
                if !visited.contains(nextPoint) {
                    visited.insert(nextPoint)
                    queue.append((nextPoint, currentPath + [pathURL]))
                }
            }
        }
        
        // 遍历完所有可达点仍未找到终点
        throw PathError.unreachable
    }
    
    func parseURL(urls: [URL], completion: ((UIBezierPath?, PathError?) -> Void)? = nil) {
        for url in urls {
            if parseFinishURLMap[url] == nil {
                print("[\(String(describing: Self.self))-\(#function)-\(Thread.current):\(#line)] 将\(url.lastPathComponent)解析")
                do {
                    let urlData = try Data(contentsOf: url)
                    let parser = XMLParser(data: urlData)
                    parser.delegate = self
                    handleParser[parser] = .init(totalURL: urls, parseURL: url, completion: completion)
                    parser.parse()
                    return
                } catch {
                    completion?(nil, .parseError)
                }
            }
        }
        
        var paths: [UIBezierPath] = []
        for url in urls {
            if let path = parseFinishURLMap[url] {
                paths.append(path)
            }
        }
        let retPath = UIBezierPath()
        paths.forEach({ retPath.append($0) })
        completion?(retPath, nil)
    }
}

extension PathSetManager {
    
    enum PathError: Error {
        case unreachable // 不可达
        case unExistFromPoint // 不存在出发点
        case unExistToPoint // 不存在到达点
        case parseError
    }
}

// MARK: - XMLParserDelegate
extension PathSetManager: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "path", let d = attributeDict["d"] {
            handleParser[parser]?.result = PathParseResult(d: d)
        } else if elementName == "circle" {
            var tmp: CircleParseResult?
            if let result = handleParser[parser]?.result as? CircleParseResult {
                tmp = result
            } else {
                tmp = CircleParseResult()
                handleParser[parser]?.result = tmp
            }
            if let cx = attributeDict["cx"] {
                tmp?.cx = cx
            }
            if let cy = attributeDict["cy"] {
                tmp?.cy = cy
            }
            if let r = attributeDict["r"] {
                tmp?.r = r
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if let model = handleParser[parser], let path = model.result?.path {
            print("[\(String(describing: Self.self))-\(#function)-\(Thread.current):\(#line)] 解析\(model.parseURL.lastPathComponent)完成")
            parseFinishURLMap[model.parseURL] = path
            handleParser[parser] = nil
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) { [weak self] in
                self?.parseURL(urls: model.totalURL, completion: model.completion ?? nil)
            }
        } else {
            print("[\(String(describing: Self.self))-\(#function)-\(Thread.current):\(#line)] 丢失")
            handleParser[parser]?.completion?(nil, .parseError)
        }
    }
}

extension PathSetManager {
    
    class PointRelation {
        
        let pointName: String
        
        var toPointArr: [(toName: String, path: URL)] = []
        
        init(pointName: String) {
            self.pointName = pointName
        }
    }
    
    class ParseDataModel: NSObject {
        
        let totalURL: [URL]
        
        var parseURL: URL
        
        var completion: ((UIBezierPath?, PathError?) -> Void)?
        
        var result: ParseResult?
        
        init(totalURL: [URL], parseURL: URL, completion: ((UIBezierPath?, PathError?) -> Void)? = nil) {
            self.totalURL = totalURL
            self.parseURL = parseURL
            self.completion = completion
        }
    }
    
    protocol ParseResult {
    
        var isCircle: Bool { get }
        
        var path: UIBezierPath? { get }
    }
    
    class PathParseResult: ParseResult {
        
        let d: String
        
        var isCircle: Bool {
            false
        }
        
        var path: UIBezierPath? {
            return UIBezierPath(pathString: d)
        }
        
        init(d: String) {
            self.d = d
        }
    }
    
    class CircleParseResult: ParseResult {
        
        var cx: String?
        
        var cy: String?
        
        var r: String?
        
        var cxValue: CGFloat? {
            if let cx, let dValue = Double(cx) {
                return dValue
            }
            return nil
        }
        
        var cyValue: CGFloat? {
            if let cy, let dValue = Double(cy) {
                return dValue
            }
            return nil
        }
        
        var rValue: CGFloat? {
            if let r, let dValue = Double(r) {
                return dValue
            }
            return nil
        }
        var isCircle: Bool {
            true
        }
        
        var path: UIBezierPath? {
            if let cxValue, let cyValue, let rValue {
                let path = UIBezierPath()
                path.addArc(withCenter: .init(x: cxValue, y: cyValue), radius: rValue, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
                return path
            }
            return nil
        }
    }
    
}


