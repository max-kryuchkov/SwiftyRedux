//
//  Store.swift
//  SwiftyRedux
//
//  Created by max kryuchkov on 21.04.2021.
//

import Combine

open class Store: ObservableObject {
    
    @Published private(set) var state: AppState
    let reducer: Reducer<AppState>
    var dispatchFunction: DispatchFunction!
    
    private var middleware: [Middleware]
    private var isDispatching = AtomicBool(false)
    
    init(state: AppState = AppState(), reducer: @escaping Reducer<AppState>, middleware: [Middleware] = []) {
        self.state = state
        self.reducer = reducer
        self.middleware = middleware
        self.dispatchFunction = middleware
            .reversed()
            .reduce({ [unowned self] action in
                self.defaultDispatch(action: action)
                }, { dispatchFunction, middleware in
                    let dispatch: (Action) -> Void = { [weak self] in self?.dispatch($0) }
                    let getState = { [weak self] in self?.state }
                    return middleware(dispatch, getState)(dispatchFunction)
                })
    }
    
    func dispatch(_ action: Action) {
        dispatchFunction(action)
    }
    
    private func defaultDispatch(action: Action) {
        guard isDispatching.value == false else {
            fatalError("Action has been dispatched while a previous action is action is being processed")
        }

        isDispatching.set(true)
        let newState = reducer(action, state)
        isDispatching.set(false)

        state = newState
    }
}
