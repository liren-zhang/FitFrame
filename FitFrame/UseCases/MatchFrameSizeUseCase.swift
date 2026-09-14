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

/// Matches a rider's target Stack and Reach against the available frames in
/// the repository.
///
/// ### Business Rules
/// - A frame is a **perfect match** if both its Stack and Reach are within
///   ±5 mm of the rider's target values.
/// - A frame is a **close match** if both are within ±15 mm but not within
///   ±5 mm.
/// - Frames outside ±15 mm are excluded from the results.
/// - When multiple frames have the same match quality, the cheaper frame is
///   ranked first, so that budget-conscious riders see the best-value option
///   at the top of the list.
///
/// - Throws: `DomainError.noMatchingFrameFound` if the input list is empty or
///   if no frame falls within the acceptable tolerance.
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