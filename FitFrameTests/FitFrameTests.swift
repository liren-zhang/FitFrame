//
//  FitFrameTests.swift
//  FitFrameTests
//
//  Created by Liren Zhang on 11/9/2026.
//
//

//
//  FitFrameTests.swift
//  FitFrameTests
//
//  Unit tests covering the three Use Cases.
//

import Testing
@testable import FitFrame

// MARK: - CalculateStackReachUseCase

@MainActor
struct CalculateStackReachTests {

    let useCase = CalculateStackReachUseCase()

    @Test func calculateStackReach_succeeds_withValidMeasurements() async throws {
        let measurements = CyclistBodyMeasurements(
            heightCM: 178, inseamCM: 82, armLengthCM: 62, torsoLengthCM: 60,
            flexibilityScore: 3, coreStrengthScore: 3
        )
        let result = try useCase.execute(measurements: measurements)
        #expect(result.targetStackMM > 500)
        #expect(result.targetStackMM < 650)
        #expect(result.targetReachMM > 0)
    }

    @Test func calculateStackReach_fails_whenMeasurementsInvalid() async throws {
        let invalid = CyclistBodyMeasurements(
            heightCM: 0, inseamCM: 82, armLengthCM: 62, torsoLengthCM: 60,
            flexibilityScore: 3, coreStrengthScore: 3
        )
        #expect(throws: DomainError.self) {
            _ = try useCase.execute(measurements: invalid)
        }
    }

    @Test func calculateStackReach_fails_whenInseamImplausible() async throws {
        let invalid = CyclistBodyMeasurements(
            heightCM: 178, inseamCM: 120, armLengthCM: 62, torsoLengthCM: 60,
            flexibilityScore: 3, coreStrengthScore: 3
        )
        #expect(throws: DomainError.self) {
            _ = try useCase.execute(measurements: invalid)
        }
    }

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
        #expect(aggressiveResult.targetStackMM < relaxedResult.targetStackMM)
    }
}

// MARK: - MatchFrameSizeUseCase

@MainActor
struct MatchFrameSizeTests {

    let useCase = MatchFrameSizeUseCase()

    @Test func matchFrameSize_returnsPerfectMatch_whenWithin5mm() async throws {
        let frame = BicycleFrameGeometry(
            brand: "Test", model: "Bike", sizeLabel: "M",
            stackMM: 545, reachMM: 388, priceAUD: 1000
        )
        let matches = try useCase.execute(
            targetStack: 545, targetReach: 388, frames: [frame]
        )
        #expect(matches.count == 1)
        #expect(matches.first?.matchQuality == .perfect)
    }

    @Test func matchFrameSize_fails_whenNoFramesAvailable() async throws {
        #expect(throws: DomainError.self) {
            _ = try useCase.execute(targetStack: 545, targetReach: 388, frames: [])
        }
    }
}

// MARK: - CompareBikeModelsUseCase

@MainActor
struct CompareBikeModelsTests {

    let useCase = CompareBikeModelsUseCase()

    @Test func compareBikeModels_returnsRecommendation_withTwoModels() async throws {
        let frameA = BicycleFrameGeometry(
            brand: "A", model: "Model A", sizeLabel: "M",
            stackMM: 545, reachMM: 388, priceAUD: 5000
        )
        let frameB = BicycleFrameGeometry(
            brand: "B", model: "Model B", sizeLabel: "M",
            stackMM: 545, reachMM: 388, priceAUD: 3000
        )
        let models = [
            BikeModel(frame: frameA, matchQuality: .perfect),
            BikeModel(frame: frameB, matchQuality: .perfect)
        ]
        let result = try useCase.execute(models: models)
        #expect(result.recommended.brand == "B")
        #expect(result.alternatives.count == 1)
    }

    @Test func compareBikeModels_fails_withLessThanTwoModels() async throws {
        let frame = BicycleFrameGeometry(
            brand: "A", model: "Model A", sizeLabel: "M",
            stackMM: 545, reachMM: 388, priceAUD: 5000
        )
        let models = [BikeModel(frame: frame, matchQuality: .perfect)]
        #expect(throws: DomainError.self) {
            _ = try useCase.execute(models: models)
        }
    }
}