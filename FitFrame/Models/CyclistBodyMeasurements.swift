//
//  CyclistBodyMeasurements.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  CyclistBodyMeasurements.swift
//  FitFrame
//
//  骑手身体数据模型：记录用于计算车架尺寸的 6 项测量数据
//

import Foundation

/// The set of body measurements a cyclist provides to FitFrame.
///
/// These six values are the minimum input required to calculate a rider's
/// target Stack and Reach. They are collected directly from the user through
/// the measurement input screen.
///
/// ### Business Rules
/// - All measurements must be positive numbers.
/// - The inseam must be smaller than the rider's height.
/// - Both assessment scores must be between 1 and 5.
///
/// - Note: Values are stored in centimeters (cm), except for the two
///   assessment scores, which are integers from 1 to 5.
struct CyclistBodyMeasurements: Codable, Equatable {
    let heightCM: Double          // 身高（厘米）
    let inseamCM: Double          // 胯高（会阴到地面）
    let armLengthCM: Double       // 臂长
    let torsoLengthCM: Double     // 躯干长（胸高 - 胯高）
    let flexibilityScore: Int     // 柔韧度：1-5，5 表示柔韧性最好
    let coreStrengthScore: Int    // 核心力量：1-5，5 表示最强

    /// 简单的有效性校验
    var isValid: Bool {
        return heightCM > 0 && inseamCM > 0 && armLengthCM > 0 &&
               torsoLengthCM > 0 && inseamCM < heightCM &&
               (1...5).contains(flexibilityScore) &&
               (1...5).contains(coreStrengthScore)
    }
}