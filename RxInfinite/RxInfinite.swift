//
//  ViewController.swift
//  RxInfinite
//
//  Created by Hyeonsu Ha on 25/06/17.
//  Copyright © 2017 GeekTree0101. All rights reserved.
//

import RxSwift

class RxInfinite<Element> {
    
    private let errorCallBack: (Error) -> (Void)
    
    required init(catchError: @escaping (Error) -> (Void)) {
        self.errorCallBack = catchError
    }
    
    private func on(event: Event<Element>) -> Observable<Element> {
        switch event {
        case .next(let element):
            return .just(element)
        case .error(let error):
            self.errorCallBack(error)
            return .empty()
        case .completed:
            return .empty()
        }
    }
    
    func shield(target observer: Observable<Element>) -> Observable<Element> {
        return observer.catchError({ error -> Observable<Element> in
            return self.on(event: .error(error))
        }).flatMap { item -> Observable<Element> in
            return self.on(event: .next(item))
        }
    }
}
