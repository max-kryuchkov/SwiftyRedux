# SwiftyRedux

SwiftyRedux is a simple Redux implementation for Swift

### Here is a tutorial for creating a demo app using SwiftyRedux

The app is pretty simple, it will change the background color on button tap

Let's start!

Add SwiftyRedux package in Swift Package Manager and import the library:

```
import SwiftyRedux
```

Now we have to create a new State, Raducer and an Action for some app's logic. So let's add a new State for new module:
```
// SubState.swift

struct SubState: StateType, Equatable {
    let value: Int
    
    func updating(value: Int) -> Self {
        .init(value: value)
    }
    
    static var initial: Self {
        .init(value: 0)
    }
}
```
> Note: It named "Sub" just for the demo, you should choose a good and intuitive name for such sub states.

Now we are ready to create a main app's state:

```
// AppState.swift

struct AppState: State {
    private(set) var subState: SubState
    
    init(subState: SubState = .initial) {
        self.subState = subState
    }
}
```

Add Actions for changing some value:

```
// SubAction.swift

protocol SubAction: Action {}

struct SubActions {
    struct NextValue: SubAction {}
    struct DidChangeValue: SubAction {}
}
```

The third part is a Reducer:

```
// SubReducer.swift

extension Reducers {
    
    static func subReducer(action: Action, subState: SubState?) -> SubState {
        var state = subState ?? .initial
        switch action {
        case _ as SubActions.NextValue:
            state = state.updating(value: state.value + 1)
        case _ as SubActions.DidChangeValue:
            break
        default:
            break
        }
        return state
    }
}
```

And also we need Reducers enum for combining all sub states and an AppState:

```
// Reducers.swift

enum Reducers: AppReducers {
    typealias S = AppState
    
    static func appReducer(action: Action, state: S?) -> S {
        AppState(subState: Reducers.subReducer(action: action, subState: state?.subState))
    }
}
```
Now we are ready to add all necessary logic to the ContentView:
```
struct ContentView: View {
    @EnvironmentObject private var store: Store<AppState>
    private let colors: [Color] = [.yellow, .gray, .indigo, .red, .mint, .green]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            Spacer()
            Text("Hello, this is SwiftyRedux demo!").padding(.bottom, 20)
            Button("Next") { store.dispatch(SettingsActions.NextValue()) }
            Spacer()
        }.background(colors[store.state.settingsState.value % colors.count])
    }
}
```

1) `@EnvironmentObject private var store: Store<AppState>` - add environment object
2) `store.dispatch(SettingsActions.NextValue())` - dispatch action with reducer
3) `store.state.settingsState.value` - use current value to change background color

### Here is one more small example how to make async tasks like HTTP requests
Create Thunk instance with async logic like this:
```
protocol NetworkAction: Action {}

struct NetworkActions {
    
    struct DidTapDownloadButton: NetworkAction {
        
        func thunk() -> Thunk {
            return Thunk { dispatch, getState in
                guard let _ = getState() else {
                    return
                }
                // Start
                dispatch(DidStart())
                // API request here...
                DispatchQueue.global().async {
                    // E.g. some logic...
                    // Finish
                    dispatch(DidFinish(value: "NEW VALUE HERE"))
                    // Error
                    dispatch(DidFinish(with: error))
                }
            }
        }
    }
}
```
And simple use in View: `store.dispatch(NetworkActions.DidTapDownloadButton())`
