//
//  Atomic.swift
//  SwiftyRedux
//
//  Created by max kryuchkov on 20.01.2022.
//

import Foundation

typealias AtomicBool = Atomic<Bool>

struct Atomic<Value> {
    private let queue = DispatchQueue(label: "com.kryuchkov.utilities.AtomicBool", attributes: .concurrent)
    private var _value: Value
    
    init(_ value: Value) {
        self._value = value
    }
    
    var value: Value {
        queue.sync {
            _value
        }
    }
    
    @discardableResult
    mutating func set(_ newValue: Value) -> Value {
        set { _ in newValue }
    }
    
    mutating func set(execute task: (inout Value) throws -> Value) rethrows -> Value {
        try queue.sync(flags: .barrier) {
            try task(&_value)
        }
    }
}
