//
//  FrameSizeRecommendation.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  FrameSizeRecommendation.swift
//  FitFrame
//
//  推荐结果模型：计算出的目标 Stack/Reach + 匹配的车架列表
//

import Foundation

/// 一次尺寸计算的输出结果
struct FrameSizeRecommendation: Equatable {
    let targetStackMM: Double                  // 目标 Stack
    let targetReachMM: Double                  // 目标 Reach
    let matchedFrames: [BicycleFrameGeometry]  // 匹配到的车架列表

    /// 显示用的 Stack 范围（±5mm）
    var stackRangeText: String {
        let lower = Int(targetStackMM - 5)
        let upper = Int(targetStackMM + 5)
        return "\(lower)–\(upper) mm"
    }

    /// 显示用的 Reach 范围（±5mm）
    var reachRangeText: String {
        let lower = Int(targetReachMM - 5)
        let upper = Int(targetReachMM + 5)
        return "\(lower)–\(upper) mm"
    }
}