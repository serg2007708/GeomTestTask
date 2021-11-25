//
//  UsersLocalStorageService.swift
//  GeoTestTask
//
//  Created by Sergiy Sobol on 24.11.2021.
//

import Foundation
import CoreData
import RxSwift
import RxDataSources
import RxCoreData

protocol UsersLocalStorageServiceProtocol: AnyObject {
    func save(users: [User]) -> Observable<[User]>
    func fetchUsers() -> Observable<[User]>
}

final class UsersLocalStorageService: UsersLocalStorageServiceProtocol {
    
    private var managedObjectContext = CoreDataManager.shared.managedObjectContext
    private let disposeBag = DisposeBag()
    
    func save(users: [User]) -> Observable<[User]> {
        return Single<[User]>.create {
            users.forEach{
                try? self.managedObjectContext?.rx.update($0)
            }
            $0(.success(users))
            return Disposables.create()
        }.asObservable()
        
    }
    
    func fetchUsers() -> Observable<[User]> {
        guard let context = managedObjectContext else {
            return Observable.just([])
        }
        return context.rx.entities(User.self)
    }
}
