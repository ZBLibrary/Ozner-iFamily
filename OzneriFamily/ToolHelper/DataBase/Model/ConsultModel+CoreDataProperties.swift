//
//  ConsultModel+CoreDataProperties.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/17.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation
import CoreData


extension ConsultModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConsultModel> {
        return NSFetchRequest<ConsultModel>(entityName: "ConsultModel");
    }

    @NSManaged public var content: String?
    @NSManaged public var type: String?
    @NSManaged public var userId: String?

}
