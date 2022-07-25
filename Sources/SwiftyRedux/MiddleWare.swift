//
//  MiddleWare.swift
//  SwiftyRedux
//
//  Created by max kryuchkov on 22.04.2021.
//

import Foundation

public typealias DispatchFunction = (Action) -> Void
public typealias Middleware = (@escaping DispatchFunction,
                               @escaping () -> AppState?) -> (@escaping DispatchFunction) -> DispatchFunction

public let loggingMiddleware: Middleware = { dispatch, getState in
    return { next in
        return { action in
            #if DEBUG
            let name = __dispatch_queue_get_label(nil)
            let queueName = String(cString: name, encoding: .utf8)
            print("🚀 #Action: \(String(reflecting: type(of: action))) on queue: \(queueName ?? "??")")
            #endif
            return next(action)
        }
    }
}
