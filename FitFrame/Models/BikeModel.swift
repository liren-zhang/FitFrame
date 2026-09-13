//
//  BikeModel.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  BikeModel.swift
//  FitFrame
//
//  兼容车架尺寸判断结果：用于 UI 显示某款车是否"完美匹配"
//

import Foundation

/// 匹配质量等级
enum MatchQuality: String {
    case perfect = "Perfect Match"      // 完美匹配
    case close = "Close"                // 接近
    case notRecommended = "Not Recommended"  // 不推荐
}

/// 单个匹配结果（车架 + 匹配质量）
struct BikeModel: Identifiable, Equatable {
    let id: UUID
    let frame: BicycleFrameGeometry
    let matchQuality: MatchQuality

    init(id: UUID = UUID(), frame: BicycleFrameGeometry, matchQuality: MatchQuality) {
        self.id = id
        self.frame = frame
        self.matchQuality = matchQuality
    }

    /// 显示用的名称，例如 "Canyon Endurace CF SL 8 (M)"
    var displayName: String {
        "\(frame.brand) \(frame.model) (\(frame.sizeLabel))"
    }
}