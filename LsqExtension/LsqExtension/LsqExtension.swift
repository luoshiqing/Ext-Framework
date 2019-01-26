//
//  LsqExtension.swift
//  LsqExtension
//
//  Created by DayHR on 2019/1/25.
//  Copyright © 2019年 zhcx. All rights reserved.
//

import UIKit

/// 字典相加
public func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
/// 延迟异步执行方法
public func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
/// 转json字符串
public func getJSONString(with data: Any)->String?{
    if !JSONSerialization.isValidJSONObject(data) {
        print("无法解析出JSONString")
        return nil
    }
    let data = try? JSONSerialization.data(withJSONObject: data, options: [])
    let jsonString = String(data: data!, encoding: .utf8)
    return jsonString
}

/// TODO:设备延展
public extension UIDevice{
    ///屏幕宽度
    public static let width: CGFloat = UIScreen.main.bounds.width
    ///屏幕高度
    public static let height: CGFloat = UIScreen.main.bounds.height
    ///状态栏高度
    public static let statusHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    ///比例
    public static let scale375: CGFloat = UIDevice.width / 375.0
    
    ///是否是iPhone X 系列
    public class var isX: Bool{
        //iPhone X, iphone xs
        if UIDevice.height == 812 && UIDevice.width == 375 {
            return true
        }
        //iPhone XR, iphone XS Max
        if UIDevice.height == 896 && UIDevice.width == 414 {
            return true
        }
        return false
    }
    
    /// 获取app版本号（获取失败则返回空字符串）
    public class var appVersion: String {
        let infoDictionary = Bundle.main.infoDictionary ?? [:]
        guard let currentAppVersion = infoDictionary["CFBundleShortVersionString"] as? String else{
            return ""
        }
        return currentAppVersion
    }
    /// 获取版本build号（获取失败则返回空字符串）
    public class var buildVersion: String{
        let infoDictionary = Bundle.main.infoDictionary ?? [:]
        guard let minorVersion = infoDictionary["CFBundleVersion"] as? String else{
            return ""
        }
        return minorVersion
    }
    /// 拨打电话
    public class func callPhone(with phone: String){
        let p = "tel://" + phone
        if let url = URL(string: p){
            if #available(iOS 10.0, *){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else{
                UIApplication.shared.openURL(url)
            }
        }
    }
}

/// TODO:Date延展
public extension Date{
    /// date->字符串
    public func toString(_ type: LsqDateFormat) -> String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = type.rawValue
        let dateStr = dateFormat.string(from: self)
        return dateStr
    }
    /// 获取一分钟的时间戳
    public static var one_minute: Double{
        return 60
    }
    /// 获取一小时的时间戳
    public static var one_hour: Double{
        return self.one_minute * 60
    }
    /// 获取一天的时间戳
    public static var one_day: Double{
        return self.one_hour * 24
    }
    
}
/// TODO:时间戳转换类型
public enum LsqDateFormat: String {
    //y表示年份，m表示月份，d表示日，h表示小时，m表示分钟，s表示秒
    case yyyy_MM_dd_HH_mm_ss    = "yyyy-MM-dd HH:mm:ss"
    case yyyy_MM_dd_HH_mm       = "yyyy-MM-dd HH:mm"
    case yyyy_MM_dd_HH          = "yyyy-MM-dd HH"
    case yyyy_MM_dd             = "yyyy-MM-dd"
    case yyyyMMdd               = "yyyy.MM.dd"
    case yyyyMM                 = "yyyy.MM"
    case yyyy_MM                = "yyyy-MM"
    case HH_mm                  = "HH:mm"
    case yyyy                   = "yyyy"
    case MM                     = "MM"
}
/// TODO:字体
public extension UIFont {
    ///根据屏幕宽度自动字体
    public class func auto(font: CGFloat)->UIFont{
        var fontSize: CGFloat = font
        fontSize *= UIDevice.scale375
        return UIFont.systemFont(ofSize: fontSize)
    }
}
/// TODO:控制器延展
public extension UIViewController{
    ///导航栏和状态栏高度
    public var navStatusHeight: CGFloat{
        return UIDevice.statusHeight + self.navHeight
    }
    ///导航栏高度（不包含状态栏高度）
    public var navHeight: CGFloat{
        return self.navigationController?.navigationBar.frame.height ?? 0
    }
}
/// TODO:颜色延展
public extension UIColor{
    ///16进制转换颜色
    public class func hexColor(with string: String) -> UIColor? {
        var cString = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.count < 6{
            return nil
        }
        if cString.hasPrefix("0X"){
            let index = cString.index(cString.startIndex, offsetBy: 2)
            cString = String(cString[index...])
        }
        if cString .hasPrefix("#"){
            let index = cString.index(cString.startIndex, offsetBy: 1)
            cString = String(cString[index...])
        }
        if cString.count != 6{
            return nil
        }
        let rrange = cString.startIndex..<cString.index(cString.startIndex, offsetBy: 2)
        let rString = String(cString[rrange])
        let grange = cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)
        let gString = String(cString[grange])
        let brange = cString.index(cString.startIndex, offsetBy: 4)..<cString.index(cString.startIndex, offsetBy: 6)
        let bString = String(cString[brange])
        var r:CUnsignedInt = 0 ,g:CUnsignedInt = 0 ,b:CUnsignedInt = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
    ///RGB颜色
    public class func rgbColor(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
}
/// TODO:字符串延展
public extension String{
    
    /// 根据文本框宽度跟字体，计算文字的高度
    public func textAutoHeight(width: CGFloat, font: UIFont) -> CGFloat{
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let ssss = NSStringDrawingOptions.usesDeviceMetrics
        let rect = string.boundingRect(with: CGSize(width: width, height: 0), options: [origin,lead,ssss], attributes: [NSAttributedString.Key.font:font], context: nil)
        return rect.height
    }
    /// 根据高度跟字体，计算文字的宽度
    public func textAutoWidth(height: CGFloat, font: UIFont)->CGFloat{
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let rect = string.boundingRect(with: CGSize(width: 0, height: height), options: [origin,lead], attributes: [NSAttributedString.Key.font:font], context: nil)
        return rect.width
    }
    /// 判断正则
    public func isRegex(with regex: Regex)->Bool{
        return LsqRegex(regex.rawValue).match(input: self)
    }
    /// 字符串转date
    public func toDate(type: LsqDateFormat)->Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        let date = formatter.date(from: self)
        return date
    }
    /// json字符串转换成字典
    public var dictionary: [String:Any]?{
        guard let data = self.data(using: .utf8) else{ return nil }
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else{
            return nil
        }
        return dict
    }
    /// 找控制器名称字符串对应的控制器
    public var viewController: UIViewController.Type?{
        guard let clsName = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            print("命名空间不存在")
            return nil
        }
        let cls: AnyClass? = NSClassFromString(clsName + "." + self)
        guard let clsType = cls as? UIViewController.Type else{
            print("无法转换成UIViewController")
            return nil
        }
        return clsType
    }
}
/// TODO:字符串操作
public extension String{
    /// 读取某个下标字符
    public subscript(index: Int)->String{
        get{//读取
            let idx = self.index(self.startIndex, offsetBy: index)
            return String(self[idx])
        }
        set{//修改
            self.remove(at: self.index(self.startIndex, offsetBy: index))
            let new = newValue
            for i in 0..<new.count{
                let character = Character(new[i])
                let idx = self.index(self.startIndex, offsetBy: index + i)
                self.insert(character, at: idx)
            }
        }
    }
    /// 读取闭区间字符串
    public subscript(rang: ClosedRange<Int>) ->String{
        let range = self.index(startIndex, offsetBy: rang.lowerBound )...self.index(startIndex, offsetBy: rang.upperBound)
        return String(self[range])
    }
    /// 读取开区间字符串
    public subscript(rang: Range<Int>) ->String{
        let range = self.index(startIndex, offsetBy: rang.lowerBound )..<self.index(startIndex, offsetBy: rang.upperBound)
        return String(self[range])
    }
}

/// TODO:图片的尺寸操作，大小压缩
public extension UIImage {
    /// 图片尺寸的压缩
    public func resizeImage() -> UIImage{
        let contrastWidth: CGFloat = 1280
        let width = self.size.width
        let height = self.size.height
        let scale = width / height
        var sizeChange = CGSize()
        if width <= contrastWidth && height < contrastWidth{
            //a，图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
            return self
        }else if width > contrastWidth || height > contrastWidth{
            //b,宽或者高大于1280，但是图片宽度高度比小于或等于2，则将图片宽或者高取大的等比压缩至1280
            if scale <= 2 && scale >= 1{
                let changeWidth: CGFloat = contrastWidth
                let changeHeight: CGFloat = changeWidth / scale
                sizeChange = CGSize(width: changeWidth, height: changeHeight)
            }else if scale >= 0.5 && scale <= 1{
                let changeHeight = contrastWidth
                let changeWidth = changeHeight * scale
                sizeChange = CGSize(width: changeWidth, height: changeHeight)
            }else if width > contrastWidth && height > contrastWidth {
                //c,宽以及高均大于1280，但是图片宽高比大于2时，则宽或者高取小的等比压缩至1280
                if scale > 2{//高的值比较小
                    let changeHeight = contrastWidth
                    let changeWidth = changeHeight * scale
                    sizeChange = CGSize(width: changeWidth, height: changeHeight)
                }else{//宽的值比较小
                    let changeWidth = contrastWidth
                    let changeHeight = changeWidth / scale
                    sizeChange = CGSize(width: changeWidth, height: changeHeight)
                }
            }else{ //d, 宽或者高，只有一个大于1280，并且宽高比超过2，不改变图片大小
                return self
            }
        }
        UIGraphicsBeginImageContext(sizeChange)
        self.draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImg!
    }
    /// 图片大小压缩（200kb左右）
    public func compressData()->Data{
        let data = self.jpegData(compressionQuality: 1)!
        let kb = data.count / 1024
        var size: CGFloat = 0.1
        if kb > 1500{
            size = 0.3
        }else if kb > 600 {
            size = 0.4
        }else if kb > 400{
            size = 0.5
        }else if kb > 300{
            size = 0.6
        }else if kb > 200{
            size = 0.8
        }else{
            size = 1
        }
        let endData = self.jpegData(compressionQuality: size)!
        return endData
    }
}

/// TODO: 时间戳转 时间(字符串)
public extension TimeInterval {
    /// 时间戳转时间(需要秒级)
    public func toDate(type: LsqDateFormat)->String{
        let date = Date(timeIntervalSince1970: self)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = type.rawValue
        let time = dateformatter.string(from: date)
        return time
    }
}

/// TODO:视图延展
public extension UIView {
    
    /// 获取视图的控制器
    public var viewController: UIViewController?{
        var next: UIResponder?
        next = self.next
        repeat{
            if (next as? UIViewController) != nil{
                return (next as? UIViewController)
            }else{
                next = next?.next
            }
        }while next != nil
        return (next as? UIViewController)
    }
    
    /// 视图高度
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: newValue)
        }
    }
    /// 视图宽度
    public var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.height)
        }
    }
    /// 视图顶部坐标(y)
    public var top: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.width, height: self.frame.height)
        }
    }
    /// 视图底部坐标(y)
    public var bottom: CGFloat{
        get{
            return self.frame.origin.y + self.frame.height
        }
        set{
            let y = newValue + self.frame.height
            self.frame = CGRect(x: self.frame.origin.x, y: y, width: self.frame.width, height: self.frame.height)
        }
    }
    /// 视图左侧坐标(x)
    public var left: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
        
    }
    /// 视图右侧坐标(x)
    public var right: CGFloat{
        get{
            return self.frame.origin.x + self.frame.width
        }
        set{
            let x = newValue - self.frame.width
            self.frame = CGRect(x: x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
    }
}
