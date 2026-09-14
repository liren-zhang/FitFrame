//
//  InputMeasurementView.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  InputMeasurementView.swift
//  FitFrame
//
//  Measurement input screen. Collects six body values from the rider.
//

import SwiftUI

struct InputMeasurementView: View {

    @StateObject private var viewModel = BodyMeasurementViewModel()
    @State private var showResult = false

    var body: some View {
        NavigationView {
            Form {

                // ───── 身体测量 ─────
                Section(header: Text("Body Measurements")) {
                    measurementField(
                        title: "Height",
                        hint: "Stand barefoot, measure from the top of your head to the floor",
                        text: $viewModel.heightText
                    )
                    measurementField(
                        title: "Inseam",
                        hint: "Wearing cycling shorts, measure from the perineum to the floor",
                        text: $viewModel.inseamText
                    )
                    measurementField(
                        title: "Arm Length",
                        hint: "Hold a pen in your palm, arm straight, measure from the pen to the top of your shoulder",
                        text: $viewModel.armLengthText
                    )
                    measurementField(
                        title: "Torso Length",
                        hint: "Distance from the sternum (bottom of breastbone) to the floor, minus your inseam",
                        text: $viewModel.torsoLengthText
                    )
                }

                // ───── 体能评估 ─────
                Section(header: Text("Physical Assessment")) {
                    scoreField(
                        title: "Flexibility",
                        legend: "Standing forward bend — 5: palms on floor · 4: fingertips within 10 cm · 3: 10–20 cm · 2: 20–30 cm · 1: over 30 cm",
                        score: $viewModel.flexibilityScore
                    )
                    scoreField(
                        title: "Core Strength",
                        legend: "Plank hold — 5: over 120 s · 4: 90–119 s · 3: 60–89 s · 2: 30–59 s · 1: under 30 s",
                        score: $viewModel.coreStrengthScore
                    )
                }

                // ───── 操作按钮 ─────
                Section {
                    Button(action: {
                        viewModel.calculate()
                        if viewModel.recommendation != nil {
                            showResult = true
                        }
                    }) {
                        Text("Calculate Frame Size")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                    }
                    .disabled(!viewModel.canCalculate)

                    Button("Reset", role: .destructive) {
                        viewModel.reset()
                    }
                }

                // ───── 错误提示 ─────
                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("FitFrame")
            .background(
                NavigationLink(
                    destination: resultDestination,
                    isActive: $showResult
                ) { EmptyView() }
            )
        }
    }

    // MARK: - 子视图

    /// 带说明文字的数字输入行
    private func measurementField(title: String, hint: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                Spacer()
                TextField("0", text: text)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 90)
                Text("cm")
                    .foregroundColor(.secondary)
            }
            Text(hint)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }

    /// 带评分标准的滑块行
    private func scoreField(title: String, legend: String, score: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                Spacer()
                Text("\(score.wrappedValue) / 5")
                    .foregroundColor(.secondary)
            }
            Slider(
                value: Binding(
                    get: { Double(score.wrappedValue) },
                    set: { score.wrappedValue = Int($0.rounded()) }
                ),
                in: 1...5,
                step: 1
            )
            Text(legend)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }

    /// 跳转目标
    @ViewBuilder
    private var resultDestination: some View {
        if let measurements = buildMeasurements() {
            RecommendationView(measurements: measurements)
        } else {
            Text("Invalid input")
        }
    }

    /// 从输入框构造领域模型
    private func buildMeasurements() -> CyclistBodyMeasurements? {
        guard let h = Double(viewModel.heightText),
              let i = Double(viewModel.inseamText),
              let a = Double(viewModel.armLengthText),
              let t = Double(viewModel.torsoLengthText) else { return nil }

        return CyclistBodyMeasurements(
            heightCM: h,
            inseamCM: i,
            armLengthCM: a,
            torsoLengthCM: t,
            flexibilityScore: viewModel.flexibilityScore,
            coreStrengthScore: viewModel.coreStrengthScore
        )
    }
}

#Preview {
    InputMeasurementView()
}