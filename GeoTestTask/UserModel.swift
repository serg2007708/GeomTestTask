//
//  UserModel.swift
//  GeoTestTask
//
//  Created by Mayorov Genrikh on 26.10.2021.
//

import CoreData
import RxCoreData
import Foundation

struct User: Codable {
    var id: Int
    var email: String
    var firstName: String
    var lastName: String?
    var avatar: String?
}

extension User {
    var fullName: String {
        firstName + " " + (lastName ?? "")
    }
}
