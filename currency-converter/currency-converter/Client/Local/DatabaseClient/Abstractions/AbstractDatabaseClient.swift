//
//  AbstractDatabaseClient.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/11/22.
//

import Foundation
import RxSwift

protocol DatabaseRepresentable {
    associatedtype T
    associatedtype ID
    
    var client: AbstractLocalStorageIntereactor {get}
    
    init(client: AbstractLocalStorageIntereactor)
}

protocol DataCreatable: DatabaseRepresentable {
    func create(item: T) -> Observable<Bool>
    func createAll(items: [T]) -> Observable<[Bool]>
}

protocol DataReadable: DatabaseRepresentable {
    func read(id: ID) -> Observable<T>
    func readAll() -> Observable<[T]>
}

protocol DataUpdatable: DatabaseRepresentable {
    func update(item: T) -> Observable<Bool>
    func updateAll(items:[T]) -> Observable<Bool>
}

protocol DataDeletable: DatabaseRepresentable {
    func delete(item: T) -> Observable<Bool>
    func deleteAll(items:[T]) -> Observable<Bool>
}


typealias AbstractDatabaseClient = DataCreatable & DataReadable & DataUpdatable & DataDeletable

