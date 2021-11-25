//
//  UsersNetworkResponse.swift
//  GeoTestTask
//
//  Created by Sergiy Sobol on 24.11.2021.
//

struct UsersNetworkResponse: Codable {
    var page: Int?
    var perPage: Int?
    var total: Int?
    var totalPage: Int?
    var data: [User]
}
