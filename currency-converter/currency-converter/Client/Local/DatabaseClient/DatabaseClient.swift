//
//  DatabaseClient.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/12/22.
//

import Foundation
import RxSwift


class DatabaseClient<I, T>: AbstractDatabaseClient {
    typealias T = T
    typealias ModelType = AbstractDataModel
    
    let interactor: AbstractLocalStorageIntereactor
    let schedular: SchedulerType
    
    required init(interactor: AbstractLocalStorageIntereactor, schedular: SchedulerType) {
        self.interactor = interactor
        self.schedular = schedular
    }
    
    func create(item: T) -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            observer.onNext(self.interactor.create(type: T.self, item: item))
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func createAll(items: [T]) -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            observer.onNext(self.interactor.createAll(type: T.self, items: items))
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func read(id: String) -> Observable<T> {
        return Observable<T>.create({ observer -> Disposable in
            observer.onNext(self.interactor.read(type: T.self, id: id))
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func readAll() -> Observable<[T]> {
        return Observable<[T]>.create({ observer -> Disposable in
            observer.onNext(self.interactor.readAll(type: T.self))
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func update(item: T) -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            observer.onNext(self.interactor.update(type: T.self, item: item))
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func updateAll(items: [T]) -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            observer.onNext(self.interactor.updateAll(type: T.self, items: items))
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func delete(item: T) -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            observer.onNext(self.interactor.delete(type: T.self, item: item))
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func deleteAll(items: [T]) -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            observer.onNext(self.interactor.deleteAll(type: T.self, items: items))
            return Disposables.create()
        }).subscribe(on: schedular)
    }
}
