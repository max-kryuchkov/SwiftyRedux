//
//  Thunk.swift
//  SwiftyRedux
//
//  Created by max kryuchkov on 27.04.2021.
//

import Foundation

open class Thunk: Action {
    
    let body: (_ dispatch: @escaping DispatchFunction, _ getState: @escaping () -> AppState?) -> Void
    
    init(body: @escaping (_ dispatch: @escaping DispatchFunction, _ getState: @escaping () -> AppState?) -> Void) {
        self.body = body
    }
}

public func createThunkMiddleware() -> Middleware {
    
    let middleware: Middleware = { dispatch, getState in
        let fun: (@escaping DispatchFunction) -> DispatchFunction = { next in
            let actionFunc: DispatchFunction = { action in
                switch action {
                case let thunk as Thunk:
                    thunk.body(dispatch, getState)
                default:
                    next(action)
                }
            }
            return actionFunc
        }
        return fun
    }
    return middleware
}
