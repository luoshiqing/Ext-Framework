//
//  LsqRegex.swift
//  LsqExtension
//
//  Created by DayHR on 2019/1/25.
//  Copyright © 2019年 zhcx. All rights reserved.
//

import UIKit

struct LsqRegex {
    private let regex: NSRegularExpression?
    init(_ pattern: String) {
        self.regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    func match(input: String) -> Bool{
        if let matches = self.regex?.matches(in: input, options: [], range: NSMakeRange(0, input.count)){
            return matches.count > 0
        }else{
            return false
        }
    }
}

///正则类型
public enum Regex: String {
    case userName   = "^[a-z0-9_-]{3,16}$"
    case phone      = "^1[0-9]{10}$"
    case idCard     = "^(\\d{14}|\\d{17})(\\d|[xX])$"
    case password   = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"
}
