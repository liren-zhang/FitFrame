//
//  MatchFrameSizeUseCase.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  MatchFrameSizeUseCase.swift
//  FitFrame
//
//  业务操作：将目标 Stack/Reach 与车架数据库匹配
//

import Foundation

/// Use Case：匹配车架尺寸
/// 业务规则：
/// 1. 车架 Stack/Reach 与目标值的差异在 ±5mm 内 → 完美匹配
/// 2. 差异在 ±15mm 内 → 接近
/// 3. 差异超过 ±15mm → 不推荐
struct MatchFrameSizeUseCase {

    private let perfectToleranceMM: Double = 5
    private let closeToleranceMM: Double = 15

    /// 执行匹配
    /// - Parameters:
    ///   - targetStack: 目标 Stack（mm）
    ///   - targetReach: 目标 Reach（mm）
    ///   - frames: 可选的车架列表
    /// - Returns: 按匹配质量排序的 BikeModel 列表
    func execute(
        targetStack: Double,
        targetReach: Double,
        frames: [BicycleFrameGeometry]
    ) throws -> [BikeModel] {

        guard !frames.isEmpty else {
            throw DomainError.noMatchingFrameFound
        }

        // 对每个车架计算匹配质量
        let results: [BikeModel] = frames.map { frame in
            let stackDiff = abs(frame.stackMM - targetStack)
            let reachDiff = abs(frame.reachMM - targetReach)

            let quality: MatchQuality
            if stackDiff <= perfectToleranceMM && reachDiff <= perfectToleranceMM {
                quality = .perfect
            } else if stackDiff <= closeToleranceMM && reachDiff <= closeToleranceMM {
                quality = .close
            } else {
                quality = .notRecommended
            }

            return BikeModel(frame: frame, matchQuality: quality)
        }

        // 过滤掉不推荐的，按质量排序
        let filtered = results
            .filter { $0.matchQuality != .notRecommended }
            .sorted { lhs, rhs in
                if lhs.matchQuality == rhs.matchQuality {
                    return lhs.frame.priceAUD < rhs.frame.priceAUD
                }
                return lhs.matchQuality == .perfect
            }

        guard !filtered.isEmpty else {
            throw DomainError.noMatchingFrameFound
        }

        return filtered
    }
}