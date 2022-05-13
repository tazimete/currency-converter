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
    func create<T>(item: T, type: T.Type) -> Observable<Bool>
    func createAll<T>(items: [T], type: T.Type) -> Observable<Bool>
}

protocol DataReadable: DatabaseClientRepresentable {
    func read<T>(id: String, type: T.Type) -> Observable<T>
    func readAll<T>(type: T.Type) -> Observable<[T]>
}

protocol DataUpdatable: DatabaseClientRepresentable {
    func update<T>(item: T, type: T.Type) -> Observable<Bool>
    func updateAll<T>(items:[T], type: T.Type) -> Observable<Bool>
}

protocol DataDeletable: DatabaseClientRepresentable {
    func delete<T>(item: T, type: T.Type) -> Observable<Bool>
    func deleteAll<T>(items:[T], type: T.Type) -> Observable<Bool>
}


typealias AbstractDatabaseClient = DataCreatable & DataReadable & DataUpdatable & DataDeletable

