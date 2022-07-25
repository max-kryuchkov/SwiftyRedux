//
//  Reducer.swift
//  SwiftyRedux
//
//  Created by max kryuchkov on 21.04.2021.
//

import Foundation

public typealias Reducer<ReducerStateType> = (_ action: Action, _ state: ReducerStateType?) -> ReducerStateType

public protocol AppReducers {
    
    static func appReducer<S: AppState>(action: Action, state: S?) -> S
}
