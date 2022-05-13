//
//  AbstractDatabaseClient.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/11/22.
//

import Foundation
import RxSwift

protocol DatabaseClientRepresentable {
    var interactor: AbstractLocalStorageIntereactor {get}
    var schedular: SchedulerType {get}
    
    init(interactor: AbstractLocalStorageIntereactor, schedular: SchedulerType)
}

protocol DataCreatable: DatabaseClientRepresentable {
    func create<T>(item: T) -> Observable<Bool>
    func createAll<T>(items: [T]) -> Observable<Bool>
}

protocol DataReadable: DatabaseClientRepresentable {
    func read<T>(id: String) -> Observable<T>
    func readAll<T>() -> Observable<[T]>
}

protocol DataUpdatable: DatabaseClientRepresentable {
    func update<T>(item: T) -> Observable<Bool>
    func updateAll<T>(items:[T]) -> Observable<Bool>
}

protocol DataDeletable: DatabaseClientRepresentable {
    func delete<T>(item: T) -> Observable<Bool>
    func deleteAll<T>(items:[T]) -> Observable<Bool>
}


typealias AbstractDatabaseClient = DataCreatable & DataReadable & DataUpdatable & DataDeletable

