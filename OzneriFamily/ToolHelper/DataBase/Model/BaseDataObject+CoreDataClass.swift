//
//  BaseDataObject+CoreDataClass.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/28.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

public class BaseDataObject: NSManagedObject {

    private class func cast<T>(object: NSManagedObject, type: T.Type) -> T {
        return object as! T
    }
    //通过ID查找
    class func cachedObjectWithID(ID: NSString) -> Self {
        return cast(object: CoreDataManager.defaultManager.autoGenerate(entityName: entityName, ID: ID), type: self)
    }
    //查找此表的全部数据
    class func allCachedObjects() -> [BaseDataObject] /* [Self] in not supported. */ {
        return CoreDataManager.defaultManager.fetchAll(entityName: entityName, error: nil)
        
    }
    //通过id删除数据
    class func deleteCachedObjectsWithID(IDArray:[NSString]) {
        CoreDataManager.defaultManager.deleteObjectsWithIDs(entityName: entityName, IDArray: IDArray)
    }
    //删除此表全部数据
    class func deleteAllCachedObjects() {
        CoreDataManager.defaultManager.deleteAllObjectsWithEntityName(entityName: entityName)
    }
        
    class var entityName: String {
        let s:String = NSStringFromClass(self)
        return s.components(separatedBy: ".").last ?? s
    }
}
extension BaseDataObject{
    class func fetchData(key: String, parameters: NSDictionary?, success: ((JSON)->Void)?, failure: ((Error)->Void)?){
        _=NetworkManager.defaultManager?.POST(key: key, parameters: parameters, success: success, failure: failure)
    }
    //传图片可以在这里扩展
    //带进度的也可以在此扩展
}
