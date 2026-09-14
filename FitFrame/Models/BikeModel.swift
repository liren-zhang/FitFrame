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

/// A frame paired with a quality rating describing how well it matches the
/// rider's target geometry.
///
/// This type is used by the comparison screen to display the shortlisted
/// frames and to select a final recommendation.
///
/// - SeeAlso: `MatchQuality` for the possible rating values.

/// Describes how closely a frame matches the rider's target Stack and Reach.
///
/// - `perfect`: Both Stack and Reach are within ±5 mm of the target.
/// - `close`: Both are within ±15 mm but not within ±5 mm.
/// - `notRecommended`: One or both values are more than ±15 mm away.
enum MatchQuality: String {
    case perfect = "Perfect Match"      // 完美匹配
    case close = "Close"                // 接近
    case notRecommended = "Not Recommended"  // 不推荐
}


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