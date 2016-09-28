//
//  User+CoreDataProperties.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/28.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var phone: String?
    @NSManaged public var email: String?
    @NSManaged public var usertoken: String?
    @NSManaged public var headimage: String?
    @NSManaged public var username: String?

}
