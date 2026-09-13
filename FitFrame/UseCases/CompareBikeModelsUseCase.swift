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

/// 对比结果
struct ComparisonResult: Equatable {
    let recommended: BicycleFrameGeometry   // 推荐的车架
    let reason: String                       // 推荐理由（面向用户）
    let alternatives: [BicycleFrameGeometry] // 备选
}

/// Use Case：对比 2–3 款车架
/// 业务规则：
/// 1. 优先选择匹配质量最高的
/// 2. 质量相同时，选择价格更低的
/// 3. 必须对比至少 2 款车架
struct CompareBikeModelsUseCase {

    func execute(models: [BikeModel]) throws -> ComparisonResult {
        guard models.count >= 2 else {
            throw DomainError.insufficientMeasurements
        }

        // 按匹配质量分组，优先 perfect
        let sorted = models.sorted { lhs, rhs in
            if lhs.matchQuality == rhs.matchQuality {
                return lhs.frame.priceUSD < rhs.frame.priceUSD
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