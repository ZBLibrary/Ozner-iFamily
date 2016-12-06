//
//  GYConactBook.swift
//  GYAdressBook
//
//  Created by zhuguangyang on 16/8/31.
//  Copyright © 2016年 Giant. All rights reserved.
//

import Foundation
import AddressBook
import AddressBookUI

class GYPersonModel: NSObject {
    
    var firstName: String = ""
    var lastName: String = ""
    var name1: String = ""
    var phoneNumber1: String = ""
    var sectionNumber: NSInteger = 0
    var friendId: String = ""
    var recordID: NSInteger = 0
    
    var rowSelected: Bool = true
    var email: String = ""
    var tel: String = ""
    /// 图片
    var icon: NSData?
}

class GYConactBook: NSObject {
    
    private var addressArr:NSArray = NSArray()
    private var persons:NSMutableArray = NSMutableArray()
    private var listContent:NSMutableArray = NSMutableArray()
    private var liast2Content:NSMutableArray = NSMutableArray()
    
    var perArr: NSMutableArray = NSMutableArray()
    var localCollation: UILocalizedIndexedCollation?
    var sectionTitles: NSMutableArray = NSMutableArray()
    
    //调用super.init() 必须初始化一些不是nullable值
    override init() {
        super.init()
        
    }
    
    
    func getAllPerson() -> String? {
        
//        let addressBookTemp = NSMutableArray()
        let addressBooks = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        
        let staticid = ABAddressBookGetAuthorizationStatus()
        
        /**
         *  拒绝授权
         */
        if staticid == ABAuthorizationStatus.denied {
            return nil
        }
        
        /// 发出通讯录的请求
        let sema = DispatchSemaphore(value: 0)
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, { (granted, error) in
            
            if (error != nil) {
                
                return
            }
            
            //判断是否授权
            if granted {
                
                print("已授权")
                sema.signal()
                
            } else {
                print("未授权")
            }
            
        })
        
        /**
         *  一直等待
         */
        sema.wait()
        
        
        let allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks).takeRetainedValue()
        
        //        let nPeople = ABAddressBookGetPersonCount(addressBooks) 
        
        var phoneString = ""
        
        for person: ABRecord in allPeople as Array {
            
//            let model = GYPersonModel()
            
            //转型错误 Could not cast value of type 'Swift.UnsafePointer<()>' (0x10274c028) to 'Swift.AnyObject' (0x10273c018).
            //http://swifter.tips/unsafe/
            // let person = CFArrayGetValueAtIndex(allPeople, i) as? ABRecordRef
            //TODO:联系人名字
//            if let abName = ABRecordCopyValue(person, kABPersonFirstNameProperty) {
//                model.name1 = abName.takeRetainedValue() as? String ?? ""
//            }
//            
//            //            if let abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty){
//            //            }
//            
//            if let abFullName = ABRecordCopyCompositeName(person) {
//                model.name1 = abFullName.takeRetainedValue() as String ?? ""
//            }
            
            let phoneValues:ABMutableMultiValue? =
                ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
            
            if phoneValues != nil {
                for i in 0..<ABMultiValueGetCount(phoneValues) {
                    
                    if let value = ABMultiValueCopyValueAtIndex(phoneValues
                        , i) {
                        var phone = value.takeRetainedValue() as! String
                        
                        if phone == "<null>" || phone == "" {
                            continue
                        }
                        
                        phone = phone.replacingOccurrences(of: "+", with: "")
                        phone = phone.replacingOccurrences(of: "-", with: "")
                        
                        phoneString = phoneString + "," + phone
                        print(phoneString)
                    }
                    
                }
                
            }
            
        }
        
        return phoneString
        
    }
    
    
    
}
