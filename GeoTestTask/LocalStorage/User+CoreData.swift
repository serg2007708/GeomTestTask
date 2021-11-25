//
//  User+CoreData.swift
//  GeoTestTask
//
//  Created by Sergiy Sobol on 24.11.2021.
//

import CoreData
import RxCoreData

extension User: Persistable {
    typealias T = NSManagedObject

    var identity: String {
        id.description
    }

    static var entityName: String {
        return "UserEntity"
    }

    static var primaryAttributeName: String {
        return "id"
    }

    init(entity: T) {
        id = entity.value(forKey: "id") as! Int
        email = entity.value(forKey: "email") as? String ?? ""
        firstName = entity.value(forKey: "firstName") as? String ?? ""
        lastName = entity.value(forKey: "lastName") as? String
        avatar = entity.value(forKey: "avatar") as? String
    }

    func update(_ entity: T) {
        entity.setValue(Int32(id), forKey: "id")
        entity.setValue(email, forKey: "email")
        entity.setValue(firstName, forKey: "firstName")
        entity.setValue(lastName, forKey: "lastName")
        entity.setValue(avatar, forKey: "avatar")

        do {
            try entity.managedObjectContext?.save()
        } catch let error {
            print(error)
        }
    }
}
