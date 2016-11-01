//
//  ConsultModel+CoreDataProperties.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/31.
//  Copyright © 2016年 net.ozner. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ConsultModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConsultModel> {
        return NSFetchRequest<ConsultModel>(entityName: "ConsultModel");
    }

    @NSManaged public var userId: String?
    @NSManaged public var content: String?
    @NSManaged public var type: String?

}
