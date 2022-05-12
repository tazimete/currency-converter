//
//  AbstractDatabaseClient.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/11/22.
//

import Foundation
import RxSwift

protocol DatabaseClientRepresentable {
    associatedtype T
    
    var interactor: AbstractLocalStorageIntereactor {get}
    var schedular: SchedulerType {get}
    
    init(interactor: AbstractLocalStorageIntereactor, schedular: SchedulerType)
}

protocol DataCreatable: DatabaseClientRepresentable {
    func create(item: T) -> Observable<Bool>
    func createAll(items: [T]) -> Observable<Bool>
}

protocol DataReadable: DatabaseClientRepresentable {
    func read(id: String) -> Observable<T>
    func readAll() -> Observable<[T]>
}

protocol DataUpdatable: DatabaseClientRepresentable {
    func update(item: T) -> Observable<Bool>
    func updateAll(items:[T]) -> Observable<Bool>
}

protocol DataDeletable: DatabaseClientRepresentable {
    func delete(item: T) -> Observable<Bool>
    func deleteAll(items:[T]) -> Observable<Bool>
}


typealias AbstractDatabaseClient = DataCreatable & DataReadable & DataUpdatable & DataDeletable

