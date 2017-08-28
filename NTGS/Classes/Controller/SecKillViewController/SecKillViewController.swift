//
//  SecKillViewController.swift
//  NTGS
//
//  Created by 殷年平 on 2017/8/7.
//  Copyright © 2017年 殷年平. All rights reserved.
//  秒杀界面

import UIKit
import WebKit
import SVProgressHUD

class SecKillViewController: BaseViewController {
    var btnBack = UIBarButtonItem()
    var ShareBtn = UIBarButtonItem()
    var SecKillWeb: WKWebView = WKWebView()
    var currURL: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kbackgroundColor
        btnBack = UIBarButtonItem(image: UIImage(named: "backblack"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SecKillViewController.toBack))
        btnBack.tintColor = UIColor.black
        ShareBtn = UIBarButtonItem(image: UIImage(named: "ShareBtn"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SecKillViewController.ShareClick))
        
        self.navigationItem.rightBarButtonItem = ShareBtn
        setUpWKwebView()
        LoadWKwebView()
    }
    // 创建WKWebView
    func setUpWKwebView(){
        SecKillWeb.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        SecKillWeb.uiDelegate = self
        SecKillWeb.navigationDelegate = self
        self.view.addSubview(SecKillWeb)
    }
    
    override func LoadWKwebView(){
        super.LoadWKwebView()
        
        let url = "http://m.tdamm.com/goods/show?id=zjc5aeb62vc9f5aa"
        let _url = NSURL(string: url)
        let request = URLRequest(url: _url! as URL)
        SecKillWeb.load(request)
        
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
        if self.SecKillWeb.canGoBack {
            self.SecKillWeb.goBack()
        }
    }
    func ShareClick(){
        let url = "http://m.tdamm.com/goods/show/fx_jk?id=\(currURL)"
        NetworkTools.shareInstance.request(requestType: .GET, URLString: url, parameters: nil) { (data, error) in
            let dict = data as! NSDictionary
            var code = dict.object(forKey: "code") as! Int
            print(dict)
            if code == 200{
                //  分享图片
                let ImageURL = (dict.object(forKey: "data") as! NSDictionary).object(forKey: "img") as! String
                //  分享标题
                let ShareTitle = (dict.object(forKey: "data") as! NSDictionary).object(forKey: "name") as! String
                //  分享副标题
                let ShareText = (dict.object(forKey: "data") as! NSDictionary).object(forKey: "ad_title") as! String
                // 图片要先加载一次，否则分享图片不会显示
                let Image = UIImageView()
                Image.frame = CGRect(x: 200, y: 200, width: 100, height: 50)
                Image.sd_setImage(with: URL(string: ImageURL), completed: nil)
                
                self.ShareURL(ShareTitle, ShareText, ImageURL, "http://m.tdamm.com/goods/show?id=\(self.currURL)")
            }else{
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK: -WKWebView代理方法
extension SecKillViewController{
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: webView.title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (aa) -> Void in
            completionHandler()
        }))
        self.present(ac, animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void){
        print("确认框")
    }
    //   WKWebView截取URL进行操作
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url?.absoluteString as Any)
        
        //  WKWebView当前URL
        let currentURL = navigationAction.request.url?.absoluteString
        currURL = (navigationAction.request.url?.getArg("id"))!
        //  对当前URL进行判断
        if (currentURL?.contains("cart/box"))!{
            self.navigationItem.leftBarButtonItem = btnBack
        }else if (currentURL?.contains("goods/pay"))!{
            let oids = navigationAction.request.url?.getArg("oids")
            getData(oids!)
            //  WKWebView不进入下个网页界面
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
        else if (currentURL?.contains("goods/show?id=zjc5aeb62vc9f5aa"))!{
            self.navigationItem.leftBarButtonItem = nil
        }else{
            self.navigationItem.leftBarButtonItem = btnBack
        }
        
        //  WKWebView进入下个网页界面
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}

