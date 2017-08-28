//
//  AppDelegate.swift
//  NTGS
//
//  Created by 殷年平 on 2017/8/7.
//  Copyright © 2017年 殷年平. All rights reserved.
//

import UIKit

let JPUSHAppKey = "3038e56cea28b044b9c3d9e5"
let JPUSHSecret = "6fa0db4aacce8378cd356f85"

let WXAppID = "wx2f4adf75bf8bb127"
//let WXAppID = "wx89a56f6175caabe8"
//let WXAppSecret = "04fb8b56a905faae964c35a21be9d724"
let WXAppSecret = "7fb798e261a5088ebe2b5d19fa5624ad"

let UMAppKey = "598d72dfc62dca1aeb0010c5"

let UMWXAppID = "wx7e3a1b4d917ca11c"
let UMWXAppSecret = "07601a296f953c6454b049b18ecec30e"

let UMSinaAppKey = "3615783845"
let UMSinaAppSecret = "5051115d5bf240a29d3308bafbfc6a26"

let UMQQAppID = "1105381611"
let UMQQAppKey = "hHG3N8K4HhpDTdJj"

var currontVersonCode : String? = ""
var lastVersonCode :String? = ""
var key = kCFBundleVersionKey as String
var rootNav: MyNavigationController!
let Main = UIStoryboard(name: "Main", bundle: nil)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate{

    var window: UIWindow?
    let SuccessPayBtn = UIButton()
    let SuccessPayView = UIView()
    let FailPayView = UIView()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //去沙盒取版本号
        lastVersonCode = UserDefaults.standard.string(forKey: key)
        //加载程序中的info.plist文件
        currontVersonCode = (Bundle.main.infoDictionary![key]) as? String
        
        if lastVersonCode != currontVersonCode {
            self.window?.rootViewController = NewFeatureViewController()
            UserDefaults.standard.set(currontVersonCode as? AnyObject, forKey: key)
            //立即保存
            UserDefaults.standard.synchronize()
        }else if AccountTool.shared.currentAccount?.account == nil{
            rootNav = MyNavigationController(rootViewController: LoginViewController())
            self.window?.rootViewController = rootNav
        }else{
            self.window?.rootViewController = MainViewController()
        }
        
        //全局设置
        UINavigationBar.appearance().tintColor = kloginNormalColor
        UITabBar.appearance().tintColor = kloginNormalColor
        
        //MARK: -注册微信
        WXApi.registerApp(WXAppID)
        
        //MARK: -友盟分享
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = UMAppKey
        
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: WXAppID, appSecret: WXAppSecret, redirectURL: "http://www.umeng.com/social")
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: UMQQAppID, appSecret: UMQQAppKey, redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: UMSinaAppKey, appSecret: UMSinaAppSecret, redirectURL: "http://sns.whalecloud.com/sina2/callback")
        UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.wechatFavorite)
        UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.sina)
        
        //MARK: -极光推送
        if #available(iOS 10.0, *){
            let entiity = JPUSHRegisterEntity()
            
            entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
                UNAuthorizationOptions.badge.rawValue |
                UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entiity, delegate: self)
        } else if #available(iOS 8.0, *) {
            let types = UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
        }else {
            let type = UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
        //点击App消除推送角标
        application.applicationIconBadgeNumber = 0
        // 参数2: 填你创建的应用生成的AppKey
        // 参数3: 可以不填
        // 参数4: 这个值生产环境为YES，开发环境为NO(BOOL值)
        JPUSHService.setup(withOption: launchOptions, appKey: JPUSHAppKey, channel: nil, apsForProduction: false)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
 
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // 极光推送后台点击消除角标
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }
    func applicationWillTerminate(_ application: UIApplication) {
            }
  
    //  微信跳转回调
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        WXApi.handleOpen(url, delegate: self)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        if result == false {
            //  调用其他SDK，例如支付宝SDK等
             WXApi.handleOpen(url, delegate: self)
        }
        return result

    }
    
    //  微信回调
    func onResp(_ resp: BaseResp!) {
        var strTitle = "支付结果"
        var strMsg = "what:\(resp.errCode)"
        print(resp.errCode)
        //  微信支付回调
        if resp.isKind(of: PayResp.self)
        {
            print("retcode = \(resp.errCode), retstr = \(resp.errStr)")
            switch resp.errCode
            {
            //  支付成功
            case 0 :
                WXPaySuccess()
            //  支付失败
            default:
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXPaySuccessNotification"), object: nil)
                WXPayFail()
            }
        }
        //  微信登录回调
        if resp.errCode == 0 && resp.type == 0 && (AccountTool.shared.currentAccount?.account == nil){//授权成功
                let response = resp as! SendAuthResp
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"), object: response.code)
        }
    }
    func WXPayFail(){
        let SuccessImage = UIImageView()
        
        SuccessPayView.backgroundColor = UIColor.white
        SuccessPayView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
        self.window?.addSubview(SuccessPayView)
        SuccessImage.center = CGPoint(x: kScreenWidth * 0.5, y: 140)
        SuccessImage.bounds = CGRect(x: 0, y: 0, width: 83, height: 95)
        SuccessImage.image = UIImage.init(named: "PayFail")
        SuccessPayView.addSubview(SuccessImage)
        SuccessPayBtn.frame = CGRect(x: 15, y: kScreenHeight * 0.5, width: kScreenWidth - 30, height: 47)
        SuccessPayBtn.layer.cornerRadius = 6.0
        SuccessPayBtn.clipsToBounds = true
        SuccessPayBtn.setBackgroundImage(UIImage.ImageFromColor(kloginNormalColor, frame: SuccessPayBtn.bounds), for: UIControlState())
        SuccessPayBtn.setBackgroundImage(UIImage.ImageFromColor(kloginHeightlightColor, frame: SuccessPayBtn.bounds), for: .highlighted)
        SuccessPayBtn.setTitle("支付失败", for: .normal)
        SuccessPayBtn.addTarget(self, action: Selector("wxPayAction"), for: .touchUpInside)
        SuccessPayView.addSubview(SuccessPayBtn)
        self.window?.bringSubview(toFront: SuccessPayView)
        UIView.animate(withDuration: 1.0, animations: {
            self.SuccessPayView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        }) { (_) in
        }
    }
    func WXPaySuccess(){
        let SuccessImage = UIImageView()
        
        SuccessPayView.backgroundColor = UIColor.white
        SuccessPayView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
        self.window?.addSubview(SuccessPayView)
        
        SuccessImage.center = CGPoint(x: kScreenWidth * 0.5, y: 140)
        SuccessImage.bounds = CGRect(x: 0, y: 0, width: 83, height: 95)
        SuccessImage.image = UIImage.init(named: "PaySuccess")
        SuccessPayView.addSubview(SuccessImage)
        SuccessPayBtn.frame = CGRect(x: 15, y: kScreenHeight * 0.5, width: kScreenWidth - 30, height: 47)
        SuccessPayBtn.layer.cornerRadius = 6.0
        SuccessPayBtn.clipsToBounds = true
        SuccessPayBtn.setBackgroundImage(UIImage.ImageFromColor(kloginNormalColor, frame: SuccessPayBtn.bounds), for: UIControlState())
        SuccessPayBtn.setBackgroundImage(UIImage.ImageFromColor(kloginHeightlightColor, frame: SuccessPayBtn.bounds), for: .highlighted)
        SuccessPayBtn.setTitle("支付成功", for: .normal)
        SuccessPayBtn.addTarget(self, action: Selector("wxPayAction"), for: .touchUpInside)
        SuccessPayView.addSubview(SuccessPayBtn)
        self.window?.bringSubview(toFront: SuccessPayView)
        UIView.animate(withDuration: 1.0, animations: {
            self.SuccessPayView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        }) { (_) in
        }
    }
    func wxPayAction(){
        UIView.animate(withDuration: 1.0, animations: {
            self.SuccessPayView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
        }) { (_) in
                
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        print(userInfo)
        completionHandler(.newData)
        application.applicationIconBadgeNumber = 0
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
}
//极光推送代理
extension AppDelegate : JPUSHRegisterDelegate{
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter willPresent");
        let userInfo = notification.request.content.userInfo
        if #available(iOS 10.0, *) {
            if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
                JPUSHService.handleRemoteNotification(userInfo)
            }
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            completionHandler(Int(UNAuthorizationOptions.alert.rawValue))
        } else {
            // Fallback on earlier versions
        }
        // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        //        let subtitle = notification.request.content.subtitle
        //        print(subtitle)
        //        let title = notification.request.content.title
        //        print(title)
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter didReceive");
        let userInfo = response.notification.request.content.userInfo
        if #available(iOS 10.0, *) {
            if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
                JPUSHService.handleRemoteNotification(userInfo)
            }
        } else {
            // Fallback on earlier versions
        }
        completionHandler()
    }
}



