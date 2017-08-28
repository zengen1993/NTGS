//
//  InvitationViewController.swift
//  NTGS
//
//  Created by 殷年平 on 2017/8/7.
//  Copyright © 2017年 殷年平. All rights reserved.
//  邀请界面

import UIKit
import WebKit
import SVProgressHUD

class InvitationViewController: BaseViewController {
    var btnBack = UIBarButtonItem()
    var ShareBtn = UIBarButtonItem()
    var InvitationWeb: WKWebView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kbackgroundColor
        btnBack = UIBarButtonItem(image: UIImage(named: "backblack"), style: UIBarButtonItemStyle.plain, target: self, action: "toBack")
        ShareBtn = UIBarButtonItem(image: UIImage(named: "ShareBtn"), style: UIBarButtonItemStyle.plain, target: self, action: "ShareClick")
        self.navigationItem.rightBarButtonItem = ShareBtn
        btnBack.tintColor = UIColor.black
        // 创建WKWebView
        self.setUpWKwebView()
        self.LoadWKwebView()
        
    }
    // 创建WKWebView
    func setUpWKwebView(){
        InvitationWeb.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        InvitationWeb.uiDelegate = self
        InvitationWeb.navigationDelegate = self
        self.view.addSubview(InvitationWeb)
    }
    override func LoadWKwebView(){
        super.LoadWKwebView()
        let url = "http://m.tdamm.com/personal/team/invite"
        let _url = NSURL(string: url)
        let request = URLRequest(url: _url! as URL)
        self.InvitationWeb.load(request)
    }
    // WKWebView返回前一个界面
    func toBack() {
        if self.InvitationWeb.canGoBack {
            self.InvitationWeb.goBack()
        }
    }
    func ShareClick() {
        ShareURL("泥土公社", "做最好吃的", "Icon", "http://m.tdamm.com/tg/show_card")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
//MARK: -WKWebView代理方法
extension InvitationViewController{
    //   WKWebView截取URL进行操作
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url?.absoluteString)
        
        //  WKWebView当前URL
        var currentURL = navigationAction.request.url?.absoluteString
        
        if (currentURL?.contains("http://a.app.qq.com/o/simple.jsp?pkgname=com.jky.bsxw"))!{
            
            ShareURL("泥土公社", "做最好吃的", "Icon", "http://m.tdamm.com/tg/show_card")
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
