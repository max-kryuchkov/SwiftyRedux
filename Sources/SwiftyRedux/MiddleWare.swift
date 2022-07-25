//
//  MiddleWare.swift
//  SwiftyRedux
//
//  Created by max kryuchkov on 22.04.2021.
//

import Foundation

public typealias DispatchFunction = (Action) -> Void
public typealias Middleware<S> = (@escaping DispatchFunction,
                                  @escaping () -> S?) -> (@escaping DispatchFunction) -> DispatchFunction

