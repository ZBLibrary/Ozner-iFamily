//
//  User+CoreDataProperties.swift
//  
//
//  Created by zhuguangyang on 16/10/31.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var email: String?
    @NSManaged public var gradename: String?
    @NSManaged public var headimage: String?
    @NSManaged public var phone: String?
    @NSManaged public var score: String?
    @NSManaged public var username: String?
    @NSManaged public var usertoken: String?

}
