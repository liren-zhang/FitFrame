//
//  CompareBikeModelsUseCase.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  CompareBikeModelsUseCase.swift
//  FitFrame
//
//  业务操作：对比多款车架，给出推荐
//

import Foundation

/// The result of comparing two or three bicycle frames.
///
/// Contains the recommended frame, a short reason written for the user, and a
/// list of the remaining frames as alternatives.
struct ComparisonResult: Equatable {
    let recommended: BicycleFrameGeometry   // 推荐的车架
    let reason: String                       // 推荐理由（面向用户）
    let alternatives: [BicycleFrameGeometry] // 备选
}

/// Compares two or three shortlisted frames and selects the best option for
/// the rider.
///
/// ### Business Rules
/// 1. At least two frames must be provided. Comparing a single frame is not a
///    meaningful operation.
/// 2. The frame with the highest match quality is preferred.
/// 3. When two frames have the same match quality, the lower-priced frame is
///    recommended. This rule directly addresses the needs of budget-conscious
///    riders who want the best value among equally suitable options.
///
/// - Throws: `DomainError.insufficientMeasurements` if fewer than two frames
///   are provided.
/// - Throws: `DomainError.noMatchingFrameFound` if the list of models is
///   empty after sorting.
struct CompareBikeModelsUseCase {

    func execute(models: [BikeModel]) throws -> ComparisonResult {
        guard models.count >= 2 else {
            throw DomainError.insufficientMeasurements
        }

        // 按匹配质量分组，优先 perfect
        let sorted = models.sorted { lhs, rhs in
            if lhs.matchQuality == rhs.matchQuality {
                return lhs.frame.priceAUD < rhs.frame.priceAUD
            }
            return lhs.matchQuality == .perfect
        }

        guard let best = sorted.first else {
            throw DomainError.noMatchingFrameFound
        }

        // 构造推荐理由
        let reason: String
        switch best.matchQuality {
        case .perfect:
            reason = "Best fit for your body measurements, and the most affordable among perfect matches."
        case .close:
            reason = "Close fit, and the most affordable option available."
        case .notRecommended:
            reason = "No ideal match found, but this is the closest option."
        }

        return ComparisonResult(
            recommended: best.frame,
            reason: reason,
            alternatives: sorted.dropFirst().map { $0.frame }
        )
    }
}