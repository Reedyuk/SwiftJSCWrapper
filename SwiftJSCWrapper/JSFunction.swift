//
//  JSFunction.swift
//  SwiftJSCWrapper
//
//  Created by Andrew Reed on 26/05/2016.
//  Copyright © 2016 Crossrails. All rights reserved.
//

import Foundation
import JavaScriptCore

protocol JSFunction {
    func bind(object: AnyObject)
    func call(this :JSThis, args :JSValue...) throws -> JSValue
    func call(this :JSThis, args :[JSValue]) throws -> JSValue
}