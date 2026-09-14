//
//  BodyMeasurementViewModel.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  BodyMeasurementViewModel.swift
//  FitFrame
//
//  Collects the rider's six measurements and triggers the calculation.
//

import Foundation
import Combine

/// ViewModel for the measurement input screen.
///
/// Owns the six input fields, validates the raw text, and calls
/// `CalculateStackReachUseCase` when the user taps Calculate.
///
/// - Note: All UI state is published, so the SwiftUI view updates
///   automatically whenever any field changes.
@MainActor
final class BodyMeasurementViewModel: ObservableObject {

    // MARK: - 输入字段（绑定到 UI 输入框）
    @Published var heightText: String = ""
    @Published var inseamText: String = ""
    @Published var armLengthText: String = ""
    @Published var torsoLengthText: String = ""
    @Published var flexibilityScore: Int = 3
    @Published var coreStrengthScore: Int = 3

    // MARK: - 输出状态
    @Published var errorMessage: String?
    @Published var recommendation: FrameSizeRecommendation?
    @Published var isLoading: Bool = false

    // MARK: - 依赖
    private let calculateUseCase = CalculateStackReachUseCase()

    // MARK: - 业务方法

    /// 触发计算，成功则设置 recommendation
    func calculate() {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        // 1. 把文本框内容转成 Double
        guard let height = Double(heightText),
              let inseam = Double(inseamText),
              let arm = Double(armLengthText),
              let torso = Double(torsoLengthText) else {
            errorMessage = DomainError.insufficientMeasurements.errorDescription
            return
        }

        // 2. 构造领域模型
        let measurements = CyclistBodyMeasurements(
            heightCM: height,
            inseamCM: inseam,
            armLengthCM: arm,
            torsoLengthCM: torso,
            flexibilityScore: flexibilityScore,
            coreStrengthScore: coreStrengthScore
        )

        // 3. 调用 Use Case
        do {
            recommendation = try calculateUseCase.execute(measurements: measurements)
        } catch let error as DomainError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Something unexpected happened. Please try again."
        }
    }

    /// 清空所有输入
    func reset() {
        heightText = ""
        inseamText = ""
        armLengthText = ""
        torsoLengthText = ""
        flexibilityScore = 3
        coreStrengthScore = 3
        errorMessage = nil
        recommendation = nil
    }

    /// 是否所有必填项都已填
    var canCalculate: Bool {
        !heightText.isEmpty && !inseamText.isEmpty &&
        !armLengthText.isEmpty && !torsoLengthText.isEmpty
    }
}