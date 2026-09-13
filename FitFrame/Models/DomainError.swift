//
//  DomainError.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  DomainError.swift
//  FitFrame
//
//  领域错误枚举：所有 Use Case 共享的错误类型
//  错误消息面向真实用户（Jay / Sam），不是开发者
//

import Foundation

enum DomainError: LocalizedError {
    case invalidMeasurement(field: String)           // 某项测量值无效
    case implausibleProportions(reason: String)      // 比例不合理
    case noMatchingFrameFound                        // 找不到匹配车架
    case insufficientMeasurements                    // 数据不完整

    /// 面向用户的错误描述（领域语言）
    var errorDescription: String? {
        switch self {
        case .invalidMeasurement(let field):
            return "Your \(field) measurement looks invalid. Please measure again and enter a positive number."
        case .implausibleProportions(let reason):
            return "Your measurements don't look quite right: \(reason). Please double-check your inseam and height."
        case .noMatchingFrameFound:
            return "We couldn't find a frame that fits your measurements. Try adjusting your flexibility or core strength score."
        case .insufficientMeasurements:
            return "Please fill in all six measurements before we can calculate your frame size."
        }
    }
}