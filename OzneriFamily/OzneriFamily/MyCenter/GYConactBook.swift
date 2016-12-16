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
import Contacts
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
        
        
        if #available(iOS 9.0, *) {
            let status = CNContactStore.authorizationStatus(for: .contacts)
            let store = CNContactStore()
            
            if status == .notDetermined {
                //
                
                store.requestAccess(for: .contacts, completionHandler: { (isRight, error) in
                    
                    if isRight {
                        print("授权成功")
                    }
                    
                })
                
            }
            
            guard status == .authorized else {
                return ""
            }
            
            
            let keys = [CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey];
            
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            var phone = ""
            var phoneString = ""
            do {
                try store.enumerateContacts(with: request, usingBlock: { (contact, stop) in
                    
                    //获取电话号码
                    let phoneNumbers = contact.phoneNumbers
                    
                    for phoneNumber in phoneNumbers {
                        
                        print(phoneNumber.value.stringValue)
                        
                        phone = phoneNumber.value.stringValue.replacingOccurrences(of: "+", with: "")
                        phone = phone.replacingOccurrences(of: "-", with: "")
                        phoneString = phoneString + "," + phone
                        
                    }
                })
                return phoneString
            } catch (let error) {
                print(error)
            }
            
            
            
        } else {
            // Fallback on earlier versions
            
            
            
        }
        return "";
    }
    
    
    
}
