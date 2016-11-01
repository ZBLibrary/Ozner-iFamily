//
//  BaseDataObject+CoreDataProperties.swift
//  
//
//  Created by zhuguangyang on 16/10/31.
//
//

import Foundation
import CoreData


extension BaseDataObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseDataObject> {
        return NSFetchRequest<BaseDataObject>(entityName: "BaseDataObject");
    }

    @NSManaged public var id: String?

}
