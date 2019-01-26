//
//  LsqButton.swift
//  LsqExtension
//
//  Created by DayHR on 2019/1/25.
//  Copyright © 2019年 zhcx. All rights reserved.
//

import UIKit


private var LsqactionDictKey: Void?
public typealias LsqButtonAction = ((UIButton) -> ())?

/// TODO:按钮延展
public extension UIButton{
    
    //TODO:属性
    //用于保存所有事件对应的闭包
    private var actionDict: (Dictionary<String, LsqButtonAction>)? {
        get {
            return objc_getAssociatedObject(self, &LsqactionDictKey) as? Dictionary<String, LsqButtonAction>
        }
        set {
            objc_setAssociatedObject(self, &LsqactionDictKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    /// 添加点击事件
    @discardableResult
    public func addTouch(upInside action: LsqButtonAction) -> UIButton{
        self.addButton(action: action, for: .touchUpInside)
        return self
    }
    
    private func addButton(action: LsqButtonAction, for controlEvents: UIControl.Event){
        
        let eventKey = String(controlEvents.rawValue)
        if var actionDict = self.actionDict {
            actionDict.updateValue(action, forKey: eventKey)
            self.actionDict = actionDict
        }else {
            self.actionDict = [eventKey: action]
        }
        switch controlEvents {
        case .touchUpInside:
            addTarget(self, action: #selector(touchUpInsideControlEvent), for: .touchUpInside)
        default:
            break
        }
    }
    
    // 响应事件
    @objc private func touchUpInsideControlEvent() {
        executeControlEvent(.touchUpInside)
    }
    @objc private func executeControlEvent(_ event: UIControl.Event) {
        let eventKey = String(event.rawValue)
        if let actionDict = self.actionDict, let action = actionDict[eventKey] {
            action?(self)
        }
    }
}

