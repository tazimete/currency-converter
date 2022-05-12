//
//  DatabaseClient.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/12/22.
//

import Foundation
import RxSwift


class DatabaseClient: AbstractDatabaseClient {
    typealias T = AbstractDataModel
    typealias ID = Int
    
    let client: AbstractLocalStorageIntereactor
    
    required init(client: AbstractLocalStorageIntereactor) {
        self.client = client
    }
    
    
    func create(item: T) -> Observable<Bool> {
//        return Observable.create({ observer -> Disposable in
//            observer.onNext(self.client.create(item: item as! NSObjectProtocol))
//            return Disposables.create()
//        })
        fatalError("Not Implemented Yet")
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
