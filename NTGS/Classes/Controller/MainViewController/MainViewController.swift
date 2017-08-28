//
//  MainViewController.swift
//  NTGS
//
//  Created by 殷年平 on 2017/8/7.
//  Copyright © 2017年 殷年平. All rights reserved.
//  UITabBarController

import UIKit

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        addChildViewControllers()
    }
    func addChildViewControllers(){
        addChildViewController(GroupBuyViewController(), title: "拼团", ImageName: "GroupBuy")
        addChildViewController(SecKillViewController(), title: "秒杀", ImageName: "SecKill")
        addChildViewController(InvitationViewController(), title: "邀请", ImageName: "Invitation")
        addChildViewController(MessageViewController(), title: "消息", ImageName: "Message")
        addChildViewController(IncomeViewController(), title: "收入", ImageName: "Income")
    }
    func addChildViewController(_ childController: BaseViewController, title: String, ImageName: String) {
        childController.title = title
        childController.tabBarItem.image = UIImage.init(named: ImageName)
        let nav = MyNavigationController(rootViewController: childController)
//        //设置全局字体偏移量
//        nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -10)
//        //设置全局字体，字体大小
//        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black,NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!], for: .normal)
//        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: kloginNormalColor,NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!], for: .selected)
        addChildViewController(nav)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  }
