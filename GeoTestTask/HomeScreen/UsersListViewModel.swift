//
//  UsersListViewModel.swift
//  GeoTestTask
//
//  Created by Mayorov Genrikh on 26.10.2021.
//

import RxCocoa
import RxSwift

final class UsersListViewModel {
    public var users = PublishSubject<[User]>()
    public var coordinator: UserListCoordinator? = nil
    private let startLoading = PublishSubject<Void>()
    private let userNetworkService: UsersNetworkServiceProtocol
    private let userLocalStorageService: UsersLocalStorageServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(
        userNetworkService: UsersNetworkServiceProtocol = UsersNetworkService(),
        userLocalStorageService: UsersLocalStorageServiceProtocol = UsersLocalStorageService()
    ) {
        self.userNetworkService = userNetworkService
        self.userLocalStorageService = userLocalStorageService
        
        setup()
    }
    
    func setup() {
        let loadLocalUsers = userLocalStorageService.fetchUsers()
        
        let loadNetworkUsers = userNetworkService.getUsers()
            .map { $0.data }
            .flatMapLatest { users in
                self.userLocalStorageService.save(users: users)
            }
        
        startLoading
            .flatMap {
                Observable.merge(loadLocalUsers, loadNetworkUsers)
            }
            .catch { error in
                loadLocalUsers
            }
            .bind(to: users)
            .disposed(by: disposeBag)
    }
    
    func getUsers() {
        startLoading.onNext(())
    }
    
    func didSelectUser(user: User) {
        coordinator?.onSelect(user: user)
    }
}
