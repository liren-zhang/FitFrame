//
//  ResultView.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  ResultView.swift
//  FitFrame
//
//  结果界面：显示目标 Stack / Reach，并链接到匹配列表和对比
//

import SwiftUI

struct RecommendationView: View {

    let measurements: CyclistBodyMeasurements

    @StateObject private var viewModel = RecommendationViewModel()
    @State private var showMatches = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // 标题
                Text("Your Target Geometry")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                // 目标 Stack / Reach 卡片
                HStack(spacing: 16) {
                    targetCard(title: "Stack", value: viewModel.stackRangeText, color: .blue)
                    targetCard(title: "Reach", value: viewModel.reachRangeText, color: .orange)
                }
                .padding(.horizontal)

                // 匹配数量
                if !viewModel.matchedModels.isEmpty {
                    Text("\(viewModel.matchedModels.count) matching bikes found")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // 查看匹配按钮
                Button(action: { showMatches = true }) {
                    Text("Browse Matching Bikes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .disabled(viewModel.matchedModels.isEmpty)

                // 错误提示
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }

                Spacer()
            }
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadRecommendation(for: measurements)
        }
        .background(
            NavigationLink(
                destination: BikeMatchView(models: viewModel.matchedModels),
                isActive: $showMatches
            ) { EmptyView() }
        )
    }

    /// 目标值卡片
    private func targetCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    RecommendationView(measurements: CyclistBodyMeasurements(
        heightCM: 178, inseamCM: 82, armLengthCM: 62, torsoLengthCM: 60,
        flexibilityScore: 3, coreStrengthScore: 3
    ))
}