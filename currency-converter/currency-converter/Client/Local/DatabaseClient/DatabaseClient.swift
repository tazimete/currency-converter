//
//  DatabaseClient.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/12/22.
//

import Foundation
import RxSwift


class DatabaseClient: AbstractDatabaseClient {
    static let shared = DatabaseClient(interactor: UserDefaults.shared as! AbstractLocalStorageIntereactor, schedular: ConcurrentDispatchQueueScheduler(qos: .utility))
    let interactor: AbstractLocalStorageIntereactor
    let schedular: SchedulerType
    
    required init(interactor: AbstractLocalStorageIntereactor, schedular: SchedulerType) {
        self.interactor = interactor
        self.schedular = schedular
    }
    
    func create<T>(item: T, type: T.Type) -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            let result = self.interactor.create(type: T.self, item: item)
            observer.onNext(result)
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func createAll<T>(items: [T], type: T.Type) -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            let result = self.interactor.createAll(type: T.self, items: items)
            observer.onNext(result)
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func read<T>(id: String, type: T.Type) -> Observable<T> {
        return Observable<T>.create({ observer -> Disposable in
            let result = self.interactor.read(type: T.self, id: id)
            observer.onNext(result)
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func readAll<T>(type: T.Type) -> Observable<[T]> {
        return Observable<[T]>.create({ observer -> Disposable in
            let result = self.interactor.readAll(type: T.self)
            observer.onNext(result)
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func update<T>(item: T, type: T.Type) -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            let result = self.interactor.update(type: T.self, item: item)
            observer.onNext(result)
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func updateAll<T>(items: [T], type: T.Type) -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            let result = self.interactor.updateAll(type: T.self, items: items)
            observer.onNext(result)
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func delete<T>(item: T, type: T.Type) -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            let result = self.interactor.delete(type: T.self, item: item)
            observer.onNext(result)
            return Disposables.create()
        }).subscribe(on: schedular)
    }
    
    func deleteAll<T>(items: [T], type: T.Type) -> Observable<Bool> {
        return Observable<Bool>.create({ observer -> Disposable in
            let result = self.interactor.deleteAll(type: T.self, items: items)
            observer.onNext(result)
            return Disposables.create()
        }).subscribe(on: schedular)
    }
}
