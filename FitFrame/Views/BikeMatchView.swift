//
//  BikeMatchView.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  BikeMatchView.swift
//  FitFrame
//
//  匹配列表界面：显示推荐的车架，可加入对比
//

import SwiftUI

struct BikeMatchView: View {

    let models: [BikeModel]

    @StateObject private var comparisonVM = ComparisonViewModel()
    @State private var showComparison = false

    var body: some View {
        List {
            ForEach(models) { model in
                BikeMatchRow(
                    model: model,
                    isSelected: comparisonVM.isSelected(model),
                    onToggle: {
                        if comparisonVM.isSelected(model) {
                            comparisonVM.removeFromComparison(model)
                        } else {
                            comparisonVM.addToComparison(model)
                        }
                    }
                )
            }
        }
        .navigationTitle("Matching Bikes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Compare (\(comparisonVM.selectedModels.count))") {
                    showComparison = true
                }
                .disabled(comparisonVM.selectedModels.count < 2)
            }
        }
        .sheet(isPresented: $showComparison) {
            ComparisonView(viewModel: comparisonVM)
        }
    }
}

/// 列表中的一行
struct BikeMatchRow: View {

    let model: BikeModel
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack(alignment: .top) {

            VStack(alignment: .leading, spacing: 4) {
                Text(model.displayName)
                    .font(.headline)

                HStack(spacing: 12) {
                    Text("Stack \(Int(model.frame.stackMM))mm")
                    Text("Reach \(Int(model.frame.reachMM))mm")
                }
                .font(.caption2)
                .foregroundColor(.secondary)

                Text("A$\(Int(model.frame.priceAUD))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }

            Spacer()

            VStack(spacing: 6) {
                qualityBadge
                Button(action: onToggle) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(isSelected ? .green : .gray)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 6)
    }

    /// 匹配质量徽章
    private var qualityBadge: some View {
        Text(model.matchQuality.rawValue)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.2))
            .foregroundColor(badgeColor)
            .cornerRadius(8)
    }

    private var badgeColor: Color {
        switch model.matchQuality {
        case .perfect: return .green
        case .close: return .orange
        case .notRecommended: return .red
        }
    }
}