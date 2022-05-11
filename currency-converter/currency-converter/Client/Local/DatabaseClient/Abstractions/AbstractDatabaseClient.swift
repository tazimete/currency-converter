//
//  AbstractDatabaseClient.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/11/22.
//

import Foundation
import RxSwift

protocol AbstractDatabaseClient {
    
}

protocol DatabaseOperation {
    associatedtype Data
    associatedtype ID
}

protocol Creatable: DatabaseOperation {
    func create(item: Data) -> Observable<Bool>
    func createAll(items: [Data]) -> Observable<[Bool]>
}

protocol Readable: DatabaseOperation {
    func read(id: ID) -> Observable<Data>
    func readAll() -> Observable<[Data]>
}

protocol Updatable: DatabaseOperation {
    func update(id: ID, item: Data) -> Observable<Bool>
    func updateAll(ids: [ID], item:[Data]) -> Observable<[Bool]>
}

protocol Deletable: DatabaseOperation {
    func delete(id: ID, item: Data) -> Observable<Bool>
    func deleteAll(ids: [ID], item:[Data]) -> Observable<[Bool]>
}
