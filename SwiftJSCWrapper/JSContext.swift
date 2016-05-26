//
//  JSContext.swift
//  SwiftJSCWrapper
//
//  Created by Andrew Reed on 26/05/2016.
//  Copyright © 2016 Crossrails. All rights reserved.
//

import Foundation
import JavaScriptCore

let bindings = NSMapTable(keyOptions: [.ObjectPointerPersonality, .WeakMemory], valueOptions: .ObjectPointerPersonality)

struct JSContext {
    
    let ref :JSContextRef
    
    init() {
        self.init(JSGlobalContextCreate(nil))
    }
    
    private init(_ ref :JSContextRef) {
        self.ref = ref
    }
    
    func eval(path :String) throws {
        let string = JSStringCreateWithCFString(try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String)
        let url = JSStringCreateWithCFString(path)
        defer {
            JSStringRelease(url)
            JSStringRelease(string)
        }
        try self.invoke {
            JSEvaluateScript(self.ref, string, nil, url, 0, &$0)
        }
    }
    
    func invoke<T>(@noescape f: (inout exception :JSValueRef ) -> T) throws -> T {
        var exception :JSValueRef = nil
        let result = f(exception: &exception)
        if exception != nil {
            print("Exception thrown: \(String(self, ref: exception))")
            throw Error(JSValue(self, ref: exception))
        }
        return result
    }
    
}

public struct Error: ErrorType, CustomStringConvertible {
    
    let exception :JSValue
    
    init(_ value: JSValue) {
        self.exception = value
    }
    
    public var description: String {
        return String(exception[message])
    }
}

private func cast(any :Any) -> JSValue? {
    if let object = any as? AnyObject {
        if let value = bindings.objectForKey(object) as? JSValue {
            return value
        }
    }
    return nil
}

func == (lhs: Any, rhs: Any) -> Bool {
    if let left = cast(lhs) {
        if let right = cast(rhs) {
            return try! left.context.invoke({
                JSValueIsEqual(left.context.ref, left.ref, right.ref, &$0)
            })
        }
    }
    return false
}
