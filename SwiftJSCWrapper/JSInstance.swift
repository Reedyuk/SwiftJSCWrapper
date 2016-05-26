//
//  JSInstance.swift
//  SwiftJSCWrapper
//
//  Created by Andrew Reed on 26/05/2016.
//  Copyright © 2016 Crossrails. All rights reserved.
//

import Foundation
import JavaScriptCore

protocol JSInstance : JSThis {
    func bind(object: AnyObject)
    func unbind(object: AnyObject)
}

extension JSValue : JSInstance {
    
    func bind(object: AnyObject) {
        bindings.setObject(self, forKey: object)
    }
    
    func unbind(object: AnyObject) {
        bindings.removeObjectForKey(object)
    }
}

extension JSContext {
    var globalObject : JSInstance {
        get {
            return JSValue(self, ref: JSContextGetGlobalObject(self.ref))
        }
    }
    
    func eval(path :String) throws -> JSInstance {
        try eval(path) as Void;
        return globalObject
    }
}

protocol JSClass : JSThis {
    func construct(args :JSValue...) throws -> JSInstance
}

extension JSValue : JSClass {
    func construct(args :JSValue...) throws -> JSInstance {
        return JSValue(context, ref: try context.invoke {
            JSObjectCallAsConstructor(self.context.ref, self.ref, args.count, args.map({ $0.ref}), &$0)
            })
    }
}

