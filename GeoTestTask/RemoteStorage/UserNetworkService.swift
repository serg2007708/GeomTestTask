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
    let getUsersPath = "/users"

    let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func getUsers() -> Observable<UsersNetworkResponse> {
        return networkService.fetch(url: networkService.baseUrl + getUsersPath)
    }
}
