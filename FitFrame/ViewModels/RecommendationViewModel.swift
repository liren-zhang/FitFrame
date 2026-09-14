//
//  RecommendationViewModel.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  RecommendationViewModel.swift
//  FitFrame
//
//  Loads the rider's recommendation and the list of matching frames.
//

import Foundation
import Combine

/// ViewModel for the results screen.
///
/// Calls `CalculateStackReachUseCase` and `MatchFrameSizeUseCase` in sequence,
/// then publishes the target geometry and the list of matching bikes.
///
/// - Important: The repository is injected so that tests can substitute a
///   fake implementation if needed.
@MainActor
final class RecommendationViewModel: ObservableObject {

    // MARK: - 输出状态
    @Published var recommendation: FrameSizeRecommendation?
    @Published var matchedModels: [BikeModel] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    // MARK: - 依赖
    private let matchUseCase = MatchFrameSizeUseCase()
    private let repository: BikeModelRepository

    init(repository: BikeModelRepository = BikeModelRepository()) {
        self.repository = repository
    }

    // MARK: - 业务方法

    /// 加载推荐结果：先计算，再匹配
    func loadRecommendation(for measurements: CyclistBodyMeasurements) {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            // 1. 计算目标 Stack / Reach
            let calcUseCase = CalculateStackReachUseCase()
            let result = try calcUseCase.execute(measurements: measurements)

            // 2. 加载车架列表
            let allFrames = try repository.loadAllFrames()

            // 3. 匹配
            let matches = try matchUseCase.execute(
                targetStack: result.targetStackMM,
                targetReach: result.targetReachMM,
                frames: allFrames
            )

            // 4. 更新状态
            recommendation = result
            matchedModels = matches

        } catch let error as DomainError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Unable to load recommendations. Please try again."
        }
    }

    /// 显示用的 Stack 范围文本
    var stackRangeText: String {
        recommendation?.stackRangeText ?? "—"
    }

    /// 显示用的 Reach 范围文本
    var reachRangeText: String {
        recommendation?.reachRangeText ?? "—"
    }
}