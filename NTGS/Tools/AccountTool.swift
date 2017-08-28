//
//  AccountTool.swift
//  TD明医
//
//  Created by work on 16/3/15.
//  Copyright © 2016年 work. All rights reserved.
//  用户类

import UIKit

let kFileName = "accounts.data"
let kCurrentName = "currentAccount.data"

class AccountTool: NSObject {
    private static var __once: () = {
            Inner.instance = AccountTool()
        }()
    var currentAccount: Account?
    var accounts: NSMutableArray?
    
    var path: String?
    var currentPath: String?
    //swift单例
    class var shared: AccountTool {
        _ = AccountTool.__once
        return Inner.instance!
    }
    struct Inner {
        static var instance: AccountTool?
        static var token: Int = 0
    }
    override init() {
        path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)[0] + ("/" + kFileName)
        print("路径：\(path)")
        currentPath =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)[0] + ("/" + kCurrentName)
        print("路径：\(currentPath)")
        //解档
        self.accounts = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as? NSMutableArray
        self.currentAccount = NSKeyedUnarchiver.unarchiveObject(withFile: currentPath!) as? Account
    
        if self.accounts == nil {
            self.accounts = NSMutableArray()
        }
        super.init()
    }
    func addAcount(_ account:Account) {
        self.accounts?.add(account)
        self.currentAccount = account
        //归档
        NSKeyedArchiver.archiveRootObject(currentAccount!, toFile: currentPath!)
        NSKeyedArchiver.archiveRootObject(self.accounts!, toFile: path!)
    }
    
    func removeAccount(_ account: Account) {
        self.accounts?.remove(account)
        self.currentAccount = nil
        
        //归档
        NSKeyedArchiver.archiveRootObject(self.accounts!, toFile: path!)
        
        //删除当前用户
        let defaultManager = FileManager.default
        if defaultManager.isDeletableFile(atPath: currentPath!) {
            do {
                try defaultManager.removeItem(atPath: currentPath!)
            }
            catch {
                print("退出失败")
            }
        }
    }
}
