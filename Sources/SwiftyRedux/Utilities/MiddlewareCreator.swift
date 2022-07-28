//
//  MiddlewareCreator.swift
//  SwiftyRedux
//
//  Created by max kryuchkov on 25.07.2022.
//

import Foundation

public protocol MiddlewareCreator {

    func createMiddleware<S: State>() -> Middleware<S>
}

public final class ThunkCreator: MiddlewareCreator {
    
    public func createMiddleware<S>() -> Middleware<S> where S : State {
        let middleware: Middleware<S> = { dispatch, getState in
            let fun: (@escaping DispatchFunction) -> DispatchFunction = { next in
                let actionFunc: DispatchFunction = { action in
                    switch action {
                    case let thunk as Thunk<S>:
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
}

public final class LoggingCreator: MiddlewareCreator {
    
    public func createMiddleware<S>() -> Middleware<S> where S : State {
        let middleware: Middleware<S> = { dispatch, getState in
            let fun: (@escaping DispatchFunction) -> DispatchFunction = { next in
                let actionFunc: DispatchFunction = { action in
                    #if DEBUG
                    let name = __dispatch_queue_get_label(nil)
                    let queueName = String(cString: name, encoding: .utf8)
                    print("🚀 #Action: \(String(reflecting: type(of: action))) on queue: \(queueName ?? "??")")
                    #endif
                    return next(action)
                }
                return actionFunc
            }
            return fun
        }
        return middleware
    }
}
