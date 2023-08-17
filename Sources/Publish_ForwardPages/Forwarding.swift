//
//  Forwarding.swift
//  
//
//  Created by Klaus Kneupner on 11/05/2023.
//

import Foundation
import Publish
import Plot

fileprivate let stepName = "CreateForwardPages"

public struct Forward {
    let from: String
    let _to: String
    
    /// on page anchor. If == nil then the whole item/page/section is linked to
    let onPage: String?
    
    ///set this to true to avoid checking whether target exists, normally when you forward outside of the site you create
    let pointsOutside: Bool
    
    public init (_ from: String, _ to: String, onPage: String? = nil) {
        self.from = from
        self.onPage = onPage
        let pointsOutside = to.starts(with: "http://") || to.starts(with: "https://")
        self.pointsOutside = pointsOutside
        self._to = pointsOutside ? to :  ensureStarts(string: to, with: "/")
    }
    
    func getTargetPath(fileMode: HTMLFileMode) -> Path {
        if pointsOutside {
            return Path(self._to)
        }
        return fileMode.filePath(string:self._to)
    }
    
    var forwardPage : HTML {
        let target = onPage != nil ? _to + "#" + onPage! : _to
        let meta = Node.meta(.http_equiv(value: .refresh),.content("0.1; url = \(target)"))
        let text = Node.h2("this is a simple forwarding page from here to ",.a(.href(target),.text(target)))
        return HTML(.head(meta),.body(text))
    }
}

fileprivate func ensureStarts(string: String, with: String) -> String {
    if string.starts(with: with) {
        return string
    }
    return with + string
}

extension PublishingContext {
    fileprivate func ensureFileExists(file: Path, message: String) throws {
        do {
            let _ =  try self.outputFile(at: file).path
        } catch  {
            throw PublishingError(stepName: stepName, infoMessage: message)
        }
    }
    
    fileprivate func throwIfTargetDoesntExist(forward: Forward) throws {
        if forward.pointsOutside {
            return // not checking outside
        }
        let targetPath = forward.getTargetPath(fileMode: self.fileMode)
        try ensureFileExists(file: targetPath, message: "Target for ForwardPage doesn't exist: \(targetPath.string)")
    }
}

public typealias ForwardTable = [Forward]

//// see for example: https://www.w3schools.com/tags/att_meta_http_equiv.asp
//public enum HTTP_Equiv_Value {
//    case contentSecurityPolicy  // Specifies a content policy for the document.
//    case contentType            // Specifies the character encoding for the document.
//    case defaultStyle           // Specified the preferred style sheet to use.
//    case refresh                // Defines a time interval for the document to refresh itself.
//    
//    public var value: String {
//        switch self {
//            case .contentSecurityPolicy: return "content-security-policy"
//            case .contentType:  return "content-type"
//            case .defaultStyle: return "default-style"
//            case .refresh:      return "refresh"
//        }
//    }
//}
//
//public extension Attribute where Context == HTML.MetaContext {
//    /// Make use of http-equiv attribute in meta tag
//    /// - parameter value: see HTTP_Equiv_Valye enum for explanation
//    static func http_equiv(value: HTTP_Equiv_Value) -> Attribute {
//        Attribute(name: "http-equiv", value: value.value)
//    }
//}

extension HTMLFileMode {

    ///Determining the right file name based on HTMLFileMode
    public func filePath(for location: Location) -> Path {
        return filePath(path: location.path)
    }
    
    ///Determining the right file name based on HTMLFileMode
    public func filePath(path: Path) -> Path {
        switch self {
            case .foldersAndIndexFiles:
                return "\(path)/index.html"
            case .standAloneFiles:
                return "\(path).html"
        }
    }
    
    ///Determining the right file name based on HTMLFileMode
    public func filePath(string: String) -> Path {
        return filePath(path: Path(string))
    }
}

extension Plugin {
    
    static public func createForwardPages(table: ForwardTable, fileMode: HTMLFileMode) throws -> Self {
        Plugin(name: stepName) { context in
            for forward in table {
                let sourceLocation = fileMode.filePath(string: forward.from)
                let source = try context.createOutputFile(at: sourceLocation)
                try context.throwIfTargetDoesntExist(forward: forward)
                let html = forward.forwardPage
                try source.write(html.render(indentedBy: nil))
            }
        }
    }
}
