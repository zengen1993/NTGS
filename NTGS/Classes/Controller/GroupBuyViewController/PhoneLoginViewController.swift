//
//  LoginVC.swift
//  TD明医
//
//  Created by 殷年平 on 2017/7/25.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class PhoneLoginViewController: UIViewController {
    
    @IBOutlet weak var LoginText: UITextField!
    @IBOutlet weak var PwdText: UITextField!
    @IBOutlet weak var PwdisHiddenBtn: UIButton!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var RegisterBtn: UIButton!
    @IBOutlet weak var FindPwdBtn: UIButton!
    var window: UIWindow?
    var accountFlag = false {
        didSet {
            if accountFlag && pwdFlag {
                if loginFlag == false {
                    loginFlag = true
                }
            } else {
                if loginFlag == true {
                    loginFlag = false
                }
            }
        }
    }
    var pwdFlag = false {
        didSet {
            if pwdFlag && accountFlag {
                if loginFlag == false {
                    loginFlag = true
                }
            } else {
                if loginFlag == true {
                    loginFlag = false
                }
            }
        }
    }
    
    var loginFlag = false {
        didSet {
            if loginFlag {
                LoginBtn.isUserInteractionEnabled = true
                LoginBtn.setBackgroundImage(UIImage.ImageFromColor(kloginNormalColor, frame: LoginBtn.bounds), for: UIControlState())
                LoginBtn.setBackgroundImage(UIImage.ImageFromColor(kloginHeightlightColor, frame: LoginBtn.bounds), for: UIControlState.highlighted)
                LoginBtn.setTitleColor(UIColor.white, for: UIControlState())
            } else {
                LoginBtn.isUserInteractionEnabled = false
                LoginBtn.setBackgroundImage(UIImage.ImageFromColor(kloginSelectColor, frame: LoginBtn.bounds), for: UIControlState())
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginText.delegate = self
        PwdText.delegate = self
        self.title = "手机登录"
        self.style()
    }
    func style(){
        
        LoginText.clearButtonMode = UITextFieldViewMode.whileEditing
        PwdText.clearButtonMode = UITextFieldViewMode.whileEditing
        PwdText.isSecureTextEntry = true
        //登录按钮
        LoginBtn.layer.cornerRadius = 6.0
        LoginBtn.clipsToBounds = true
        LoginBtn.setBackgroundImage(UIImage.ImageFromColor(kloginSelectColor, frame: LoginBtn.bounds), for: UIControlState())
        LoginBtn.isUserInteractionEnabled = false
        LoginBtn.addTarget(self, action: Selector("LonginBtnClick"), for: .touchUpInside)
        LoginBtn.setTitleColor(UIColor.white, for: UIControlState())
        //显示密码按钮
        PwdisHiddenBtn.setImage(UIImage(named: "eyes1"), for: .selected)
        PwdisHiddenBtn.addTarget(self, action: Selector("isHiddenBtnClick"), for: .touchUpInside)
        //注册按钮
        RegisterBtn.setTitleColor(UIColor.black, for: UIControlState())
        RegisterBtn.addTarget(self, action: Selector("RegisterClick"), for: .touchUpInside)
        
        FindPwdBtn.addTarget(self, action: Selector("FindPwdBtnClikc"), for: .touchUpInside)
        
        LoginText.addTarget(self, action: #selector(PhoneLoginViewController.accountChange), for: .editingChanged)
        PwdText.addTarget(self, action: #selector(PhoneLoginViewController.pwdChange), for: .editingChanged)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //  开始输入账号
    func accountChange(){
        if (LoginText.text! as NSString).length > 0 {
            if self.accountFlag == false {
                self.accountFlag = true
            }
        } else {
            if self.accountFlag == true {
                self.accountFlag = false
            }
        }
    }
    //  开始输入密码时
    func pwdChange(){
        if (PwdText.text! as NSString).length > 0 {
            if self.pwdFlag == false {
                self.pwdFlag = true
            }
        } else {
            if self.pwdFlag == true {
                self.pwdFlag = false
            }
        }
    }
    // 是否显示密码
    func isHiddenBtnClick(){
        PwdText.isSecureTextEntry = !PwdText.isSecureTextEntry
        PwdisHiddenBtn.isSelected = !PwdisHiddenBtn.isSelected
    }
    
    
    //  登录按钮
    func LonginBtnClick(){
        if LoginText.text == "373" && PwdText.text == "123456"{
            let account = Account()
            account.account = LoginText.text
            AccountTool.shared.addAcount(account)
            let vc = MainViewController()
            self.present(vc, animated: true, completion: nil)
            self.window?.rootViewController = vc
        }
    }
    
    //  注册按钮
    func RegisterClick(){
        let alert = UIAlertController(title: "系统通知", message: "暂不提供注册", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: { (UIAlertAction) in
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //  找回密码
    func FindPwdBtnClikc(){
        let alert = UIAlertController(title: "系统通知", message: "暂不提找回密码", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: { (UIAlertAction) in
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    //  键盘回收
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFieldShouldEndEditing(PwdText)
        textFieldShouldEndEditing(LoginText)
    }
    //键盘回收
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension PhoneLoginViewController: UITextFieldDelegate{
    //限制输入
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        let strLength:NSInteger = (textField.text! as NSString).length - range.length + (string as NSString).length
        //
        //        return (strLength <= 5)
        if textField == LoginText{
            let length = string.lengthOfBytes(using: String.Encoding.utf8)
            for loopIndex in 0..<length {
                //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
                let char = (string as NSString).character(at: loopIndex)
                if char < 48 { return false }
                if (char > 57 && char < 65) { return false } //
                if (char > 90 && char < 97) { return false }
                if (char > 122) { return false }
            }
            return true
        }
        return true
    }
}

