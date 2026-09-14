//
//  ComparisonView.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  ComparisonView.swift
//  FitFrame
//
//  对比界面：并排展示 2–3 款车架，并给出推荐
//

import SwiftUI

struct ComparisonView: View {

    @ObservedObject var viewModel: ComparisonViewModel

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // 对比表格
                    HStack(alignment: .top, spacing: 12) {
                        ForEach(viewModel.selectedModels) { model in
                            comparisonColumn(model: model)
                        }
                    }
                    .padding(.horizontal)

                    // 对比按钮
                    Button(action: { viewModel.compare() }) {
                        Text("Compare and Recommend")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .disabled(viewModel.selectedModels.count < 2)

                    // 推荐结果
                    if let result = viewModel.comparisonResult {
                        recommendationCard(result: result)
                    }

                    // 错误
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Compare")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    /// 单列对比
    private func comparisonColumn(model: BikeModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.frame.brand)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(model.frame.model)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)

            Divider()

            infoRow("Size", model.frame.sizeLabel)
            infoRow("Stack", "\(Int(model.frame.stackMM)) mm")
            infoRow("Reach", "\(Int(model.frame.reachMM)) mm")
            infoRow("Price", "A$\(Int(model.frame.priceAUD))")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
        }
    }

    /// 推荐结果卡片
    private func recommendationCard(result: ComparisonResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                Text("Recommended")
                    .font(.headline)
            }

            Text("\(result.recommended.brand) \(result.recommended.model) (\(result.recommended.sizeLabel))")
                .font(.title3)
                .fontWeight(.bold)

            Text(result.reason)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    ComparisonView(viewModel: ComparisonViewModel())
}