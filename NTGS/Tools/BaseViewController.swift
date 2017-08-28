//
//  BaseViewController.swift
//  NTGS
//
//  Created by 殷年平 on 2017/8/14.
//  Copyright © 2017年 殷年平. All rights reserved.
//  Controller基类

import UIKit
import WebKit
import SVProgressHUD
import ReachabilitySwift
import SDWebImage

class BaseViewController: UIViewController{
    var reach = Reachability()
    var hudTool: HUDTool!
    var imageview = UIImageView()
    var connectBtn = UIButton()
    var Coverview = UIView()
    let SuccessPayBtn = UIButton()
    let SuccessPayView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkStatusListener()
        Coverview.frame = CGRect(x: kScreenWidth, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
        Coverview.backgroundColor = UIColor.white

        Coverview.addSubview(imageview)
        Coverview.addSubview(connectBtn)
        self.view.addSubview(Coverview)
        login()
        setHud()
        
        
//        NotificationCenter.default.addObserver(self,selector: #selector(WXPaySuccess(notification:)),name: NSNotification.Name(rawValue: "WXPaySuccessNotification"),object: nil)
    }
    func login(){
        let myQueue = DispatchQueue(label: "登录")
        let group = DispatchGroup()
        group.enter()
        myQueue.async(group: group, qos: .userInitiated, flags: [], execute: {
            let url = "http://m.tdamm.com/welcome/clear?uid=\((AccountTool.shared.currentAccount?.account)!)"
            NetworkTools.shareInstance.login(url, finished: { (data, error) in
                group.leave()
                print("登录微信")
            })
        })
        group.enter()
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            let url1 = "http://m.tdamm.com/goods/shop/show"
            NetworkTools.shareInstance.login(url1, finished: { (data, error) in
                group.leave()
                print("登录店铺")
            })
        })
        //执行完上面的两个耗时操作, 回到myQueue队列中执行下一步的任务
        group.notify(queue: .main) {
            print("登录成功")
        }
    }
    func setHud() {
        hudTool = HUDTool(view: self.view)
    }
    func NetworkStatusListener() {
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    // 无网络时弹出
    func LoadWKwebView() {
        if reach?.isReachableViaWiFi == true || reach?.isReachableViaWWAN == true{
            UIView.animate(withDuration: 0.25, animations: {
                self.Coverview.frame = CGRect(x: kScreenWidth, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
            })
        }else {
            imageview.frame = CGRect(x: 0, y: 64, width: kScreenWidth, height: kScreenHeight - 64 - 49)
            imageview.image = UIImage(named: "net_Wifi")
            
            let btnWidth = kScreenWidth * 0.7

            connectBtn.frame = CGRect(x: kScreenWidth * 0.15, y: kScreenHeight * 0.75, width: btnWidth, height: 44)
            connectBtn.setTitle("重新加载", for: .normal)
            connectBtn.setTitleColor(UIColor.white, for: .normal)
            connectBtn.layer.cornerRadius = 6.0
            connectBtn.clipsToBounds = true
            connectBtn.setBackgroundImage(UIImage.ImageFromColor(kloginNormalColor, frame: connectBtn.bounds), for: UIControlState())
            connectBtn.setBackgroundImage(UIImage.ImageFromColor(kloginHeightlightColor, frame: connectBtn.bounds), for: .highlighted)
            connectBtn.addTarget(self, action: #selector(BaseViewController.LoadWKwebView), for: .touchUpInside)
            self.view.backgroundColor = kbackgroundColor
            Coverview.frame = self.view.frame
        }
    }
    // 主动检测网络状态
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        
        if reachability.isReachable { // 判断网络连接状态
            print("网络连接：可用")
            if reachability.isReachableViaWiFi { // 判断网络连接类型
                print("连接类型：WiFi")
                // strServerInternetAddrss = getHostAddress_WLAN() // 获取主机IP地址 192.168.31.2 小米路由器
                // processClientSocket(strServerInternetAddrss)    // 初始化Socket并连接，还得恢复按钮可用
            } else {
                print("连接类型：移动网络")
                // getHostAddrss_GPRS()  // 通过外网获取主机IP地址，并且初始化Socket并建立连接
            }
        } else {
            print("网络连接：不可用")
            DispatchQueue.main.async { // 不加这句导致界面还没初始化完成就打开警告框，这样不行
                self.alert_noNetwrok() // 警告框，提示没有网络
            }
        }
    }
    func ShareURL(_ title: String, _ descr: String, _ thumbImage: String, _ webpageUrl: String){
        UMSocialUIManager.showShareMenuViewInWindow { (shreMenuView, platformType) -> Void in
            let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
            //2.分享分享网页
            let shareObject:UMShareWebpageObject = UMShareWebpageObject.init()
            shareObject.title = title//显不显示有各个平台定
            shareObject.descr = descr//显不显示有各个平台定
      
            if thumbImage == "Icon"{
                shareObject.thumbImage = UIImage.init(named: "\(thumbImage)")//缩略图，显不显示有各个平台定
            }else{
                let Image = UIImageView()
                Image.sd_setImage(with: URL(string: thumbImage))
                shareObject.thumbImage = Image.image
            }
            shareObject.webpageUrl = webpageUrl
            messageObject.shareObject = shareObject
            
            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (shareResponse, error) -> Void in
                if error != nil {
                    print("Share Fail with error ：%@", error)
                }else{
                    print("Share succeed")
                }
            })
        }
    }
    // 警告框，提示没有连接网络 *********************
    func alert_noNetwrok() -> Void {
        SVProgressHUD.showError(withStatus: "请您检查网络设置")
    }
    // 移除消息通知
    deinit {
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
        // 移除SVProgressHUD
        SVProgressHUD.dismiss()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubview(toFront: Coverview)
        self.view.bringSubview(toFront: hudTool.hud)
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension BaseViewController: WKUIDelegate, WKNavigationDelegate,UIWebViewDelegate{
    //  WKWebView开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载")
        SVProgressHUD.showInfo(withStatus: "正在加载...")
    }
    //  WKWebView加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        print("加载完成")
    }
    // 加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("加载失败")
        if reach?.isReachableViaWiFi == false && reach?.isReachableViaWWAN == false{
            let alert = UIAlertController(title: "系统提示", message: "加载失败", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) -> Void in
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        SVProgressHUD.dismiss()
    }
   }
