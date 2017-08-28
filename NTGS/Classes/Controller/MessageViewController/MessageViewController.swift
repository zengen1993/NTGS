//
//  MessageViewController.swift
//  NTGS
//
//  Created by 殷年平 on 2017/8/7.
//  Copyright © 2017年 殷年平. All rights reserved.
//  消息界面

import UIKit
import WebKit
import SVProgressHUD

class MessageViewController: BaseViewController {
    var btnBack = UIBarButtonItem()
    var MessageWeb: WKWebView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kbackgroundColor
        btnBack = UIBarButtonItem(image: UIImage(named: "backblack"), style: UIBarButtonItemStyle.plain, target: self, action: "toBack")
        btnBack.tintColor = UIColor.black
        self.setUpWKwebView()
        self.LoadWKwebView()
       
    }
    // 创建WKWebView
    func setUpWKwebView(){
        MessageWeb.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        MessageWeb.uiDelegate = self
        MessageWeb.navigationDelegate = self
        self.view.addSubview(MessageWeb)
    }
    override  func LoadWKwebView(){
        super.LoadWKwebView()
        let url = "http://m.tdamm.com/chat/main/msg_list"
        let _url = NSURL(string: url)
        let request = URLRequest(url: _url! as URL)
        self.MessageWeb.load(request)
    }
    // WKWebView返回前一个界面
    func toBack() {
        if self.MessageWeb.canGoBack {
            self.MessageWeb.goBack()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
//MARK: -WKWebView代理方法
extension MessageViewController{
    //   WKWebView截取URL进行操作
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url?.absoluteString)
        
        //  WKWebView当前URL
        var currentURL = navigationAction.request.url?.absoluteString
        
        if (currentURL?.contains("main/msg_list"))!{
            self.navigationItem.leftBarButtonItem = nil
        }else{
            self.navigationItem.leftBarButtonItem = btnBack
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }

    
}
