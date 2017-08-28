//
//  IncomeViewController.swift
//  NTGS
//
//  Created by 殷年平 on 2017/8/7.
//  Copyright © 2017年 殷年平. All rights reserved.
//  收入界面

import UIKit
import WebKit
import SVProgressHUD

class IncomeViewController: BaseViewController{
    var window: UIWindow?
    var btnBack = UIBarButtonItem()
    var IncomeWeb: WKWebView = WKWebView()  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kbackgroundColor
        btnBack = UIBarButtonItem(image: UIImage(named: "backblack"), style: UIBarButtonItemStyle.plain, target: self, action: "toBack")
        btnBack.tintColor = UIColor.black
        setUpWKwebView()
        LoadWKwebView()
    }
    // 创建WKWebView
    func setUpWKwebView(){
        IncomeWeb.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        IncomeWeb.uiDelegate = self
        IncomeWeb.navigationDelegate = self
        IncomeWeb.customUserAgent = "app/ntgs"
        self.view.addSubview(IncomeWeb)
    }
    override func LoadWKwebView(){
        super.LoadWKwebView()
        let url = "http://m.tdamm.com/personal/center"
        let _url = URL(string: url)
        let request = URLRequest(url: _url!)
        self.IncomeWeb.load(request)
    }
    //  通过订单号调起微信支付
    func getData(_ oids: String){
        let url = "http://m.tdamm.com/goods/pay/paydo"
        let parameters: [String : AnyObject] = ["oids": oids as AnyObject, "pay_type": "wxpay" as AnyObject]
        NetworkTools.shareInstance.request(requestType: .POST, URLString: url, parameters: parameters) { (data, error) in
            let dict = data as! NSDictionary
            var code = dict.object(forKey: "code") as! Int
            if code == 200{
                let pay_info = (dict.object(forKey: "data") as! NSDictionary).object(forKey: "pay_info") as! NSDictionary
                let prepay_id = pay_info.object(forKey: "prepay_id") as! String
                //                let sign1 = (dict.object(forKey: "data") as! NSDictionary).object(forKey: "sign") as! String
                let noncestr = (dict.object(forKey: "data") as! NSDictionary).object(forKey: "noncestr") as! String
                let time = (dict.object(forKey: "data") as! NSDictionary).object(forKey: "timestamp") as! Int
                let strA = "appid=\(WXAppID)&noncestr=\(noncestr)&package=Sign=WXPay&partnerid=1486465992&prepayid=\(prepay_id)&timestamp=\(time)"
                
                //调起微信支付
                let req = PayReq()
                req.openID = WXAppID
                req.partnerId = "1486465992"
                req.package = "Sign=WXPay"
                req.prepayId = prepay_id
                req.nonceStr = noncestr
                req.timeStamp = UInt32(time)
                req.sign = ("\(strA)&key=EJsQkLJUjWeZUfcfCaCBOrVpA8PHeH62").MD5.uppercased()
                WXApi.send(req)
            }
        }
    }
    // WKWebView返回前一个界面
    func toBack() {
        if self.IncomeWeb.canGoBack{
            self.IncomeWeb.goBack()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
//MARK: -WKWebView代理方法
extension IncomeViewController{
    //   WKWebView截取URL进行操作
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url?.absoluteString)
        
        //  WKWebView当前URL
        var currentURL = navigationAction.request.url?.absoluteString
        print(currentURL)
        // 我的消息
        if (currentURL?.contains("chat/main/msg_list"))!{
            self.tabBarController?.selectedIndex = 3
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
        //微信支付
        else if (currentURL?.contains("goods/pay"))!{
            let oids = navigationAction.request.url?.getArg("oids")
            getData(oids!)
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
        // 邀请好友
        else if (currentURL?.contains("tg/show_card"))!{
            self.tabBarController?.selectedIndex = 2
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
        // 退出登录
        else if (currentURL?.contains("personal/personal/center/logout"))!{
            let account = Account()
            AccountTool.shared.removeAccount(account)
            let vc = LoginViewController()
            self.present(vc, animated: true, completion: nil)
            window?.rootViewController = vc
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
        // 我的设置
        else if (currentURL?.contains("personal/center/setting"))!{
            self.navigationItem.leftBarButtonItem = btnBack
        }
        // 收入主界面
        else if (currentURL?.contains("personal/center"))!{
            self.navigationItem.leftBarButtonItem = nil
            self.hudTool.webHide()
        }
        else{
            self.navigationItem.leftBarButtonItem = btnBack
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
