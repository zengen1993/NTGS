//
//  Account.swift
//  A猫监理
//
//  Created by work on 16/7/20.
//  Copyright © 2016年 work. All rights reserved.
//  用户对象

import UIKit

class Account: NSObject, NSCoding {
    // 用户登录UID
    var account: String?
    
    override init() {
        super.init()
    }
    //MARK: -归档方法
    func encode(with aCoder: NSCoder) {
        if self.account != nil {
            let tmpAccount = self.account!
            aCoder.encode(tmpAccount, forKey: "account")
       
           
        }
    }
    //MARK: -解档方法
    required init?(coder aDecoder: NSCoder) {
        super.init()
        let tmpAccount = aDecoder.decodeObject(forKey: "account") as? String
        if tmpAccount != nil {
            self.account = tmpAccount
          
        }
    }
}
