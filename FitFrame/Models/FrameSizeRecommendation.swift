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

/// The output of a bike sizing calculation.
///
/// Contains the rider's target Stack and Reach (in millimeters), plus a list
/// of frames that fall within the acceptable tolerance. The Stack and Reach
/// ranges are displayed to the user as a ±5 mm band around the target value.
///
/// - Important: A recommendation is only valid if the rider's measurements
///   pass the validation performed by `CalculateStackReachUseCase`.
struct FrameSizeRecommendation: Equatable {
    let targetStackMM: Double                  // 目标 Stack
    let targetReachMM: Double                  // 目标 Reach
    let matchedFrames: [BicycleFrameGeometry]  // 匹配到的车架列表

    // 显示用的 Stack 范围（±5mm）
    var stackRangeText: String {
        let lower = Int(targetStackMM - 5)
        let upper = Int(targetStackMM + 5)
        return "\(lower)–\(upper) mm"
    }

    // 显示用的 Reach 范围（±5mm）
    var reachRangeText: String {
        let lower = Int(targetReachMM - 5)
        let upper = Int(targetReachMM + 5)
        return "\(lower)–\(upper) mm"
    }
}