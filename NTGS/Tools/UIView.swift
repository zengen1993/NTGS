//
//  UIView.swift
//  SwiftWB
//
//  Created by 殷年平 on 2017/7/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

extension UIView{
    //一个view的底部
    func viewBottomY() ->CGFloat {
        let y = self.frame.origin.y + self.frame.size.height
        return y
    }
    
    //一个view的右边
    func viewRightX() ->CGFloat {
        let x = self.frame.origin.x + self.frame.size.width
        return x
    }
}
extension String{
    //分割字符
    func split(_ s:String)->[String]{
        if s.isEmpty{
            var x=[String]()
            for y in self.characters{
                x.append(String(y))
            }
            return x
        }
        return self.components(separatedBy: s)
    }
    //检查是否包含某个字符串
    func has(_ search:String)->Bool{
        let range = self.range(of: search)
        
        if range != nil {
            return true
        }
        else{
            return false
        }
    }
    // MD5 加密字符串
    var MD5: String {
        let cStr = self.cString(using: .utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString()
        for i in 0..<16 {
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }

}
extension URL{
    
    //得到网址里的某一参数
    func getArg(_ k:String)->String{
        var substr:String?
        let sarr = self.query?.split("?")
        if (sarr?.count)! <= 1{
            if (self.query?.has(k) != nil) {
                let p = "(?<=" + k + "\\=)[^&]+";
                
                let range = self.query?.range(of: p, options: NSString.CompareOptions.regularExpression, range: nil, locale: nil)
                
                if range != nil {
                    substr = self.query?.substring(with: range!)
                }
                
            }
        }else{
            
            for parameter in self.query!.components(separatedBy: "&") {
                
                let parts = parameter.components(separatedBy: "=")
                if parts.count > 1{
                    let key = (parts[0] as NSString).replacingPercentEscapes(using: String.Encoding.utf8.rawValue)
                    let value = (parts[1] as NSString).replacingPercentEscapes(using: String.Encoding.utf8.rawValue)
                    if key != nil && value != nil && key == k{
                        substr = value
                    }
                }
            }
        }
        
        if substr == nil {
            substr = ""
        }
        
        return substr!
    }
}

