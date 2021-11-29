//
//  NetworkService.swift
//  GeoTestTask
//
//  Created by Sergiy Sobol on 24.11.2021.
//

import RxSwift

protocol UsersNetworkServiceProtocol {
    func getUsers() -> Observable<UsersNetworkResponse>
}

final class UsersNetworkService: UsersNetworkServiceProtocol {
    private let getUsersPath = "/users"

    let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkClient()) {
        self.networkService = networkService
    }

    func getUsers() -> Observable<UsersNetworkResponse> {
        return networkService.fetch(url: getUsersPath)
    }
}
