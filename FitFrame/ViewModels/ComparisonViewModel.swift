//
//  ComparisonViewModel.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  ComparisonViewModel.swift
//  FitFrame
//
//  Manages the shortlisted frames and runs the comparison.
//

import Foundation
import Combine

/// ViewModel for the comparison screen.
///
/// Holds up to three selected bikes and calls `CompareBikeModelsUseCase`
/// when the user taps Compare. The comparison result contains the
/// recommended frame and the remaining alternatives.
///
/// - Note: A maximum of three frames can be compared at once to keep the
///   side-by-side layout readable on a phone screen.
@MainActor
final class ComparisonViewModel: ObservableObject {

    // MARK: - 状态
    @Published var selectedModels: [BikeModel] = []
    @Published var comparisonResult: ComparisonResult?
    @Published var errorMessage: String?

    // MARK: - 依赖
    private let compareUseCase = CompareBikeModelsUseCase()

    // MARK: - 业务方法

    /// 添加一款车到对比列表（最多 3 款）
    func addToComparison(_ model: BikeModel) {
        guard !selectedModels.contains(where: { $0.id == model.id }) else { return }
        guard selectedModels.count < 3 else {
            errorMessage = "You can compare up to 3 bikes at a time."
            return
        }
        selectedModels.append(model)
        errorMessage = nil
    }

    /// 从对比列表移除
    func removeFromComparison(_ model: BikeModel) {
        selectedModels.removeAll { $0.id == model.id }
        comparisonResult = nil
    }

    /// 是否已加入对比
    func isSelected(_ model: BikeModel) -> Bool {
        selectedModels.contains { $0.id == model.id }
    }

    /// 执行对比
    func compare() {
        errorMessage = nil
        do {
            comparisonResult = try compareUseCase.execute(models: selectedModels)
        } catch let error as DomainError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Unable to compare. Please try again."
        }
    }

    /// 清空
    func clear() {
        selectedModels = []
        comparisonResult = nil
        errorMessage = nil
    }
}