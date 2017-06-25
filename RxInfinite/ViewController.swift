//
//  ViewController.swift
//  RxInfinite
//
//  Created by Hyeonsu Ha on 25/06/17.
//  Copyright © 2017 GeekTree0101. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet var pureDoggy: UIImageView!
    @IBOutlet var zoombieDoggy: UIImageView!
    
    @IBOutlet var pureSuccessCount: UILabel!
    @IBOutlet var pureFailedCount: UILabel!
    
    @IBOutlet var zoombieSuccessCount: UILabel!
    @IBOutlet var zoombieFailedCount: UILabel!
    
    @IBOutlet var pureDogSave: UIButton!
    @IBOutlet var killPureDog: UIButton!
    @IBOutlet var zoombieDogSave: UIButton!
    @IBOutlet var killZoombieDog: UIButton!
    
    let disposeBag = DisposeBag()
    let pureDoggyPublisher = PublishSubject<Bool>()
    let zoombieDoggyPublisher = PublishSubject<Bool>()
    
    var pureDoggyOnSuccessCount: Int = 0
    var pureDoggyOnErrorCount: Int = 0
    
    var zoombieDoggyOnSuccessCount: Int = 0
    var zoombieDoggyOnErrorCount: Int = 0
    
    enum DoggyError: Error {
        case death
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pureDogSave.rx.tap.subscribe(onNext: { _ in
            self.pureDoggyPublisher.onNext(false)
        }).disposed(by: disposeBag)
        
        killPureDog.rx.tap.subscribe(onNext: { _ in
            self.pureDoggyPublisher.onNext(true)
        }).disposed(by: disposeBag)
        
        zoombieDogSave.rx.tap.subscribe(onNext: { _ in
            self.zoombieDoggyPublisher.onNext(false)
        }).disposed(by: disposeBag)
        
        killZoombieDog.rx.tap.subscribe(onNext: { _ in
            self.zoombieDoggyPublisher.onNext(true)
        }).disposed(by: disposeBag)
        
        let pureObserver = pureDoggyPublisher.flatMapLatest({ willKill -> Observable<Void> in
            return self.doggyEvent(willKill: willKill)
        })
        
        pureObserver.subscribe(onNext: { _ in
            self.pureDoggyOnSuccessCount += 1
            self.pureSuccessCount.text = "success: \(self.pureDoggyOnSuccessCount)"
            self.pureDoggy.image = #imageLiteral(resourceName: "dogEmit")
        }, onError: { _ in
            self.pureDoggyOnErrorCount += 1
            self.pureFailedCount.text = "error: \(self.pureDoggyOnErrorCount)"
            self.pureDoggy.image = #imageLiteral(resourceName: "dogError")
        }).disposed(by: disposeBag)
        
        
        let enternalLife = RxInfinite<Void>(catchError: { _ in
            self.zoombieDoggyOnErrorCount += 1
            self.zoombieFailedCount.text = "error: \(self.zoombieDoggyOnErrorCount)"
            self.zoombieDoggy.image = #imageLiteral(resourceName: "dogError")
        })
        
        let zoombieObserver = zoombieDoggyPublisher.flatMapLatest({ willKill -> Observable<Void> in
            return enternalLife.shield(target: self.doggyEvent(willKill: willKill))
        })
        
        zoombieObserver.subscribe(onNext: { _ in
            self.zoombieDoggyOnSuccessCount += 1
            self.zoombieSuccessCount.text = "success: \(self.zoombieDoggyOnSuccessCount)"
            self.zoombieDoggy.image = #imageLiteral(resourceName: "dogEmit")
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func doggyEvent(willKill: Bool) -> Observable<Void> {
        return Observable<Void>.create({ observer in
        
            if willKill {
                observer.onError(DoggyError.death)
            } else {
                observer.onNext(())
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
}

