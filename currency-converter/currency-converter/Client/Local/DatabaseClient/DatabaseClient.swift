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
    typealias ID = I
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
    
    func createAll(items: [T]) -> Observable<[Bool]> {
        fatalError("Not Implemented Yet")
    }
    
    func read(id: ID) -> Observable<T> {
        fatalError("Not Implemented Yet")
    }
    
    func readAll() -> Observable<[T]> {
        fatalError("Not Implemented Yet")
    }
    
    func update(item: T) -> Observable<Bool> {
        fatalError("Not Implemented Yet")
    }
    
    func updateAll(items: [T]) -> Observable<Bool> {
        fatalError("Not Implemented Yet")
    }
    
    func delete(item: T) -> Observable<Bool> {
        fatalError("Not Implemented Yet")
    }
    
    func deleteAll(items: [T]) -> Observable<Bool> {
        fatalError("Not Implemented Yet")
    }
}
