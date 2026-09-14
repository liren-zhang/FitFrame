//
//  FitFrameTests.swift
//  FitFrameTests
//
//  Created by Liren Zhang on 11/9/2026.
//
//
//  FitFrameTests.swift
//  FitFrameTests
//
//  单元测试：覆盖 3 个 Use Case 的核心业务规则
//  使用 Swift Testing 框架
//

import Testing
@testable import FitFrame

// MARK: - CalculateStackReachUseCase 测试

@MainActor
struct CalculateStackReachTests {

    let useCase = CalculateStackReachUseCase()

    /// 正常输入应返回合理的 Stack/Reach 值
    @Test func calculateStackReach_succeeds_withValidMeasurements() async throws {
        let measurements = CyclistBodyMeasurements(
            heightCM: 178, inseamCM: 82, armLengthCM: 62, torsoLengthCM: 60,
            flexibilityScore: 3, coreStrengthScore: 3
        )

        let result = try useCase.execute(measurements: measurements)

        // Stack 应该在合理范围（约 545–585 mm）
        #expect(result.targetStackMM > 500)
        #expect(result.targetStackMM < 650)

        // Reach 应该为正数
        #expect(result.targetReachMM > 0)
    }

    /// 缺失数据应抛出 invalidMeasurement 错误
    @Test func calculateStackReach_fails_whenMeasurementsInvalid() async throws {
        let invalid = CyclistBodyMeasurements(
            heightCM: 0, inseamCM: 82, armLengthCM: 62, torsoLengthCM: 60,
            flexibilityScore: 3, coreStrengthScore: 3
        )

        #expect(throws: DomainError.self) {
            _ = try useCase.execute(measurements: invalid)
        }
    }

    /// 胯高比例不合理应抛出错误
    @Test func calculateStackReach_fails_whenInseamImplausible() async throws {
        let invalid = CyclistBodyMeasurements(
            heightCM: 178, inseamCM: 120, armLengthCM: 62, torsoLengthCM: 60,
            flexibilityScore: 3, coreStrengthScore: 3
        )

        #expect(throws: DomainError.self) {
            _ = try useCase.execute(measurements: invalid)
        }
    }

    /// 高柔韧 + 高核心 → 更激进的姿势 → 更低的 Stack
    @Test func calculateStackReach_returnsLowerStack_forAggressiveRider() async throws {
        let relaxed = CyclistBodyMeasurements(
            heightCM: 178, inseamCM: 82, armLengthCM: 62, torsoLengthCM: 60,
            flexibilityScore: 1, coreStrengthScore: 1
        )
        let aggressive = CyclistBodyMeasurements(
            heightCM: 178, inseamCM: 82, armLengthCM: 62, torsoLengthCM: 60,
            flexibilityScore: 5, coreStrengthScore: 5
        )

        let relaxedResult = try useCase.execute(measurements: relaxed)
        let aggressiveResult = try useCase.execute(measurements: aggressive)

        // 激进骑手的 Stack 应该更低（更趴）
        #expect(aggressiveResult.targetStackMM < relaxedResult.targetStackMM)
    }
}

// MARK: - MatchFrameSizeUseCase 测试

@MainActor
struct MatchFrameSizeTests {

    let useCase = MatchFrameSizeUseCase()

    /// 目标值接近某车架 → 应返回完美匹配
    @Test func matchFrameSize_returnsPerfectMatch_whenWithin5mm() async throws {
        let frame = BicycleFrameGeometry(
            brand: "Test", model: "Bike", sizeLabel: "M",
            stackMM: 545, reachMM: 388, priceAUD: 1000, category: .allRound
        )

        let matches = try useCase.execute(
            targetStack: 545, targetReach: 388, frames: [frame]
        )

        #expect(matches.count == 1)
        #expect(matches.first?.matchQuality == .perfect)
    }

    /// 空车架列表应抛出错误
    @Test func matchFrameSize_fails_whenNoFramesAvailable() async throws {
        #expect(throws: DomainError.self) {
            _ = try useCase.execute(targetStack: 545, targetReach: 388, frames: [])
        }
    }
}

// MARK: - CompareBikeModelsUseCase 测试

@MainActor
struct CompareBikeModelsTests {

    let useCase = CompareBikeModelsUseCase()

    /// 对比 2 款车 → 应返回推荐
    @Test func compareBikeModels_returnsRecommendation_withTwoModels() async throws {
        let frameA = BicycleFrameGeometry(
            brand: "A", model: "Model A", sizeLabel: "M",
            stackMM: 545, reachMM: 388, priceAUD: 5000, category: .allRound
        )
        let frameB = BicycleFrameGeometry(
            brand: "B", model: "Model B", sizeLabel: "M",
            stackMM: 545, reachMM: 388, priceAUD: 3000, category: .allRound
        )

        let models = [
            BikeModel(frame: frameA, matchQuality: .perfect),
            BikeModel(frame: frameB, matchQuality: .perfect)
        ]

        let result = try useCase.execute(models: models)

        // 质量相同时应选择更便宜的
        #expect(result.recommended.brand == "B")
        #expect(result.alternatives.count == 1)
    }

    /// 少于 2 款车应抛出错误
    @Test func compareBikeModels_fails_withLessThanTwoModels() async throws {
        let frame = BicycleFrameGeometry(
            brand: "A", model: "Model A", sizeLabel: "M",
            stackMM: 545, reachMM: 388, priceAUD: 5000, category: .allRound
        )
        let models = [BikeModel(frame: frame, matchQuality: .perfect)]

        #expect(throws: DomainError.self) {
            _ = try useCase.execute(models: models)
        }
    }
}