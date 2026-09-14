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
//  输入界面：收集用户 6 项身体数据
//

import SwiftUI

struct InputMeasurementView: View {

    @StateObject private var viewModel = BodyMeasurementViewModel()

    /// 计算完成后是否跳转到结果页
    @State private var showResult = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Body Measurements (cm)")) {
                    measurementField("Height", text: $viewModel.heightText)
                    measurementField("Inseam", text: $viewModel.inseamText)
                    measurementField("Arm Length", text: $viewModel.armLengthText)
                    measurementField("Torso Length", text: $viewModel.torsoLengthText)
                }

                Section(header: Text("Physical Assessment")) {
                    scorePicker("Flexibility", score: $viewModel.flexibilityScore)
                    scorePicker("Core Strength", score: $viewModel.coreStrengthScore)
                }

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

    /// 测量输入框
    private func measurementField(_ title: String, text: Binding<String>) -> some View {
        HStack {
            Text(title)
            Spacer()
            TextField("0", text: text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 100)
            Text("cm")
                .foregroundColor(.secondary)
        }
    }

    /// 1–5 分滑块
    private func scorePicker(_ title: String, score: Binding<Int>) -> some View {
        VStack(alignment: .leading) {
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

    /// 从输入构造领域模型
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