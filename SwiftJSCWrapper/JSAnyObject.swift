//
//  JSAnyObject.swift
//  SwiftJSCWrapper
//
//  Created by Andrew Reed on 26/05/2016.
//  Copyright © 2016 Crossrails. All rights reserved.
//

import Foundation
import JavaScriptCore

class JSAnyObject {
    
    let this :JSValue;
    
    init(_ instance :JSValue) {
        this = instance
        this.bind(self)
    }
    
    deinit {
        this.unbind(self)
    }
    
}