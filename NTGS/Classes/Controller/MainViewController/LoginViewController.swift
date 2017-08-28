//
//  LoginViewController.swift
//  NTGS
//
//  Created by 殷年平 on 2017/8/8.
//  Copyright © 2017年 殷年平. All rights reserved.
//  登录界面

import UIKit
import WebKit
import SVProgressHUD

class LoginViewController: UIViewController {
    var window: UIWindow?
    var LoginBtn: MyLoginBtn = MyLoginBtn()
    var LoginView: UIImageView = UIImageView()
    let ceshi = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        LoginView.image = UIImage(named: "BackImage")
        self.view.addSubview(LoginView)
        self.title = "登录"
        LoginBtn.frame = CGRect(x: (kScreenWidth - 282)/2, y: kScreenHeight * 0.9, width: 282, height: 47)
        LoginBtn.layer.cornerRadius = 6.0
        LoginBtn.clipsToBounds = true
        LoginBtn.setBackgroundImage(UIImage.ImageFromColor(kloginNormalColor, frame: LoginBtn.bounds), for: UIControlState())
        LoginBtn.setBackgroundImage(UIImage.ImageFromColor(kloginHeightlightColor, frame: LoginBtn.bounds), for: .highlighted)
        LoginBtn.alpha = 0
        if UIApplication.shared.canOpenURL(URL(fileURLWithPath: "weixin://")){
            LoginBtn.setTitle("微信一键登录", for: .normal)
            LoginBtn.setImage(UIImage.init(named: "LoginBtn"), for: .normal)
        }else{
            LoginBtn.setTitle("手机登录", for: .normal)
        }
        LoginBtn.addTarget(self, action: Selector("wxLoginBtnAction"), for: .touchUpInside)
        self.view.backgroundColor = kbackgroundColor
        
        // 微信登录通知
        NotificationCenter.default.addObserver(self,selector: #selector(WXLoginSuccess(notification:)),name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"),object: nil)
        
        self.view.addSubview(LoginBtn)
        // 淡入动画
        StartAnimation()
    }
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    //  微信登录
    func wxLoginBtnAction() {
        if UIApplication.shared.canOpenURL(URL(fileURLWithPath: "weixin://")) && ceshi == 1 {
            let urlStr = "weixin://"
            if UIApplication.shared.canOpenURL(URL.init(string: urlStr)!) {
                let req = SendAuthReq()
                req.scope = "snsapi_userinfo,snsapi_login"
                req.state = "NTGS"
                WXApi.send(req)
            }else{
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!)
                }
            }
        }else {
            let vc = Main.instantiateViewController(withIdentifier: "PhoneLoginViewController") as! PhoneLoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    // 微信登录成功通知
    func WXLoginSuccess(notification:Notification) {
        let code = notification.object as! String
        let url = "http://m.tdamm.com/api/app/login?code=\(code)"
        NetworkTools.shareInstance.request(requestType: .POST, URLString: url, parameters: nil) { (data, error) in
            let dict = data as! NSDictionary
            var code = dict.object(forKey: "code") as! Int
            if code == 200{
                let infoma = dict.object(forKey: "data") as! NSDictionary
                let uid = infoma.object(forKey: "uid") as! String
                let account = Account()
                account.account = uid
                AccountTool.shared.addAcount(account)
                let vc = MainViewController()
                self.present(vc, animated: true, completion: nil)
                self.window?.rootViewController = vc
            }
        }
    }
    //  淡入动画
    func StartAnimation(){
        UIView.animate(withDuration: 2.0, animations: { 
            self.LoginBtn.alpha = 1.0
        }) { (_) in
            
        }
    }
}
extension LoginViewController: WKUIDelegate, WKNavigationDelegate{
    //页面开始加载
    func  webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.showInfo(withStatus: "正在加载")
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        SVProgressHUD.dismiss()
    }
}

