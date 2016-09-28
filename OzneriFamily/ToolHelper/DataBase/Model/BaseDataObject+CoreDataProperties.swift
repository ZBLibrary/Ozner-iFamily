//
//  BaseDataObject+CoreDataProperties.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/28.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation
import CoreData


extension BaseDataObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseDataObject> {
        return NSFetchRequest<BaseDataObject>(entityName: "BaseDataObject");
    }

    @NSManaged public var id: String?

}
