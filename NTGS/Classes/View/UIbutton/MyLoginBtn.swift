//
//  LoginBtn.swift
//  NTGS
//
//  Created by 殷年平 on 2017/8/9.
//  Copyright © 2017年 殷年平. All rights reserved.
//

import UIKit

class MyLoginBtn: UIButton {

    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = CGRect(x: 50, y: 6, width: 36, height: 30)
    }
}
