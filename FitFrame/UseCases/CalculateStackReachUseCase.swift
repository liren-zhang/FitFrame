//
//  CalculateStackReachUseCase.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  CalculateStackReachUseCase.swift
//  FitFrame
//
//  业务操作：根据骑手身体数据计算目标 Stack 和 Reach
//

import Foundation

/// 骑行姿势等级（由柔韧度和核心力量总分决定）
enum RidingPosture {
    case relaxed      // 休闲：2–4 分
    case neutral      // 中立：5–7 分
    case aggressive   // 激进：8–10 分

    /// Stack 校正值（厘米），来自简化公式
    var stackCorrectionCM: Double {
        switch self {
        case .relaxed: return 3
        case .neutral: return 0
        case .aggressive: return -2
        }
    }

    /// Reach 姿势参数
    var reachFactor: Double {
        switch self {
        case .relaxed: return 0.52
        case .neutral: return 0.535
        case .aggressive: return 0.545
        }
    }
}

/// Use Case：计算目标 Stack 与 Reach
/// 业务规则：
/// 1. 柔韧度 + 核心力量总分决定骑行姿势
/// 2. Stack = 0.69 × 胯高 + 校正值（cm）
/// 3. Reach = (躯干长 + 臂长) × 姿势参数 − 坐高 × 0.29 + 100 − 204（mm）
struct CalculateStackReachUseCase {

    /// 执行计算
    func execute(measurements: CyclistBodyMeasurements) throws -> FrameSizeRecommendation {
        // 1. 校验数据完整性
        guard measurements.isValid else {
            throw DomainError.invalidMeasurement(field: "body")
        }

        // 2. 校验比例合理性：胯高不能超过身高的一半
        guard measurements.inseamCM < measurements.heightCM * 0.6 else {
            throw DomainError.implausibleProportions(reason: "inseam is too long compared to height")
        }

        // 3. 计算骑行姿势等级
        let totalScore = measurements.flexibilityScore + measurements.coreStrengthScore
        let posture: RidingPosture
        switch totalScore {
        case 2...4:  posture = .relaxed
        case 5...7:  posture = .neutral
        default:     posture = .aggressive
        }

        // 4. 计算 Stack（厘米 → 毫米）
        let stackCM = 0.69 * measurements.inseamCM + posture.stackCorrectionCM
        let stackMM = stackCM * 10

        // 5. 计算坐高（用于 Reach 公式）
        let saddleHeightCM = 0.885 * measurements.inseamCM

        // 6. 计算 Reach（全部转为毫米）
        let torsoAndArmMM = (measurements.torsoLengthCM + measurements.armLengthCM) * 10
        let reachMM = torsoAndArmMM * posture.reachFactor
                    - (saddleHeightCM * 0.29) * 10
                    + 100 - 204

        // 7. 返回推荐结果（匹配列表暂为空）
        return FrameSizeRecommendation(
            targetStackMM: stackMM,
            targetReachMM: reachMM,
            matchedFrames: []
        )
    }
}