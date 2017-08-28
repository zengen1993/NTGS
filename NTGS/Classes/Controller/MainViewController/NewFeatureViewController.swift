//
//  NewFeatureViewController.swift
//  NTGS
//
//  Created by 殷年平 on 2017/8/16.
//  Copyright © 2017年 殷年平. All rights reserved.
//  引导页界面

import UIKit
let kCount = 3

class NewFeatureViewController: UIViewController {
    var window: UIWindow?
    var NewScrollView :UIScrollView!
    var pageView : UIPageControl!
    let loginBtn : UIButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewSize = self.view.bounds
        //创建scrollView
        NewScrollView = UIScrollView()
        NewScrollView.delegate = self
        NewScrollView.frame = self.view.bounds
        print(self.view.bounds.width)
        NewScrollView.contentSize = CGSize(width: kScreenWidth * CGFloat(kCount), height: 0)
        NewScrollView.showsHorizontalScrollIndicator = false
        NewScrollView.isPagingEnabled = true
        
        //创建pageControl
        pageView = UIPageControl()
        pageView.center = CGPoint(x: kScreenWidth * 0.5,y: kScreenHeight * 0.95)
        pageView.bounds = CGRect(x: 0,y: 0,width: 100,height: 0)
        pageView.numberOfPages = kCount
        pageView.setValue(UIImage.init(named: "page_Image"), forKey: "pageImage")
        pageView.setValue(UIImage.init(named: "page_currentPage"), forKey: "currentPageImage")
        
        for  i in 0..<kCount {
            self.addImageViewAtIndex(i)
            
        }
        
        self.view.addSubview(NewScrollView)
        self.view.addSubview(pageView)
    }
    
    func addImageViewAtIndex(_ Index: Int){
        let imageView :UIImageView = UIImageView()
        imageView.frame = CGRect(x: kScreenWidth * CGFloat(Index),y: 0,width: kScreenWidth,height: kScreenHeight)
        imageView.image = UIImage(named: "new_feature_\(Index+1)")
        NewScrollView.addSubview(imageView)
        if Index == 2
        {
            addButton()
        }
    }
    func addButton()
    {
        loginBtn.center = CGPoint(x: kScreenWidth * 2.5,y: pageView.viewBottomY() - 43)
        loginBtn.bounds = CGRect(x: 0 ,y: 0,width: 160,height: 37)
        loginBtn.setImage(UIImage.init(named:"new_feature_finish_button" ), for: UIControlState.normal)
        loginBtn.setImage(UIImage(named: "new_feature_finish_button_highlighted"), for: UIControlState.highlighted)
        loginBtn.addTarget(self, action: #selector(NewFeatureViewController.start), for: .touchUpInside)
        NewScrollView.addSubview(loginBtn)
    }
    func start(){
        let vc = LoginViewController()
        self.present(vc, animated: true, completion: nil)
        window?.rootViewController = vc
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
}
extension NewFeatureViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageView.currentPage = Int(NewScrollView.contentOffset.x) / Int(NewScrollView.frame.size.width)
    }
}
