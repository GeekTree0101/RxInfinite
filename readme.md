## RxInfinite

When you enter Error then Never Die, Protect your Observer during interaction

## Code Example

Initialization RxInfinite
```swift

    let rxInfinite = RxInfinite<Void>(catchError: { error in
        //TODO: Error Handling Script at here

    })
```

Shield Your Observer after Emit Event
```swift
    // shield(target: Observable<Element>)

    let observer = buttonTapPublisher.flatMapLatest({ param -> Observable<Void> in
            return rxInfinite.shield(target: API.getJSON(param))
    })

    observer.subscribe(onNext: ... )
```

## Motivation

A short description of the motivation behind the creation and maintenance of the project. This should explain **why** the project exists.

## Installation

this code will export to CocoaPod

## License

The MIT License