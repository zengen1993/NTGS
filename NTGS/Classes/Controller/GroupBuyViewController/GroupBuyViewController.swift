//
//  GroupBuyViewController.swift
//  NTGS
//
//  Created by 殷年平 on 2017/8/7.
//  Copyright © 2017年 殷年平. All rights reserved.
//  拼团界面

import UIKit
import WebKit
import SVProgressHUD
import ReachabilitySwift
import SDWebImage

let reachability = Reachability()!

class GroupBuyViewController: BaseViewController{
   
    var btnBack = UIBarButtonItem()
    var GroupBuyWeb: WKWebView = WKWebView()
    var BackView: UIImageView = UIImageView()
    var reloadBtn: UIButton = UIButton()
    var currID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kbackgroundColor
        btnBack = UIBarButtonItem(image: UIImage(named: "backblack"), style: UIBarButtonItemStyle.plain, target: self, action: "toBack")
        btnBack.tintColor = UIColor.black
        print("当前用户UID：" + (AccountTool.shared.currentAccount?.account)!)
        setUpWKwebView()
        LoadWKwebView()
    }
    // 创建WKWebView
    func setUpWKwebView(){
        GroupBuyWeb.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        GroupBuyWeb.uiDelegate = self
        GroupBuyWeb.navigationDelegate = self
    
        self.view.addSubview(GroupBuyWeb)
    }
    override func LoadWKwebView(){
        super.LoadWKwebView()
        
        DispatchQueue.global().async {
            let url2 = "http://m.tdamm.com/goods/events/shop_xs?app_jk=ap_cs"
            NetworkTools.shareInstance.request(requestType: .GET, URLString: url2, parameters: nil) { (data, error) in
                guard data != nil else {
                    print(error)
                    return
                }
                let dict = data as! NSDictionary
                var code = dict.object(forKey: "code") as! Int
                if code == 200{
                    let id = (dict.object(forKey: "data") as! NSDictionary).object(forKey: "shop_id") as! String
                    self.currID = id
                    //回到主线程加载WebView
                    DispatchQueue.main.async(execute: {
//                let url = "http://m.tdamm.com/goods/events/eventsShow?id=\(id)"
                        let url = "http://m.tdamm.com/goods/show?id=\(id)"
                        let _url = URL(string: url)
                        let request = URLRequest(url: _url!)
                        self.GroupBuyWeb.load(request)
                    })
                }else{
                    
                }
            }
        }
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
        if self.GroupBuyWeb.canGoBack {
            self.GroupBuyWeb.goBack()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
//MARK: -WKWebView代理方法
extension GroupBuyViewController{
    //   WKWebView截取URL进行操作
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //  WKWebView当前URL
        let currentURL = navigationAction.request.url?.absoluteString
        print("当前URL :\(currentURL ?? "当前链接为空")")
        
        //  对当前URL进行判断
        if (currentURL?.contains("cart/box"))!{
            self.navigationItem.leftBarButtonItem = btnBack
        }
        else if (currentURL?.contains("goods/pay?"))!{
            let oids = navigationAction.request.url?.getArg("oids")
            getData(oids!)
            //  WKWebView不进入下个网页界面
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
//        else if (currentURL?.contains("goods/shareGroup?"))!{
//            let wechat_id = navigationAction.request.url?.getArg("wechat_id")
//            if wechat_id != ""{
//                let url = currentURL! + "gh_4051c88ed7cd"
//                let _url = URL(string: url)
//                let request = URLRequest(url: _url!)
//                self.GroupBuyWeb.load(request)
//            }
//            decisionHandler(WKNavigationActionPolicy.allow)
//        }
        else if (currentURL?.contains("goods/show?id=\(currID)"))!{
            self.navigationItem.leftBarButtonItem = nil
        }else{
            self.navigationItem.leftBarButtonItem = btnBack
        }
        //  WKWebView进入下个网页界面
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
