//
//  BicycleFrameGeometry.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  BicycleFrameGeometry.swift
//  FitFrame
//
//  车架几何模型：描述一款车架的核心几何数据
//

import Foundation

/// 一款车架的几何参数
/// Stack = 五通到车头管顶部的垂直距离
/// Reach = 五通到车头管顶部的水平距离
struct BicycleFrameGeometry: Codable, Equatable, Identifiable {
    let id: UUID
    let brand: String             // 品牌，例如 "Canyon"
    let model: String             // 型号，例如 "Endurace CF SL 8"
    let sizeLabel: String         // 尺码标签，例如 "M"
    let stackMM: Double           // Stack（毫米）
    let reachMM: Double           // Reach（毫米）
    let priceAUD: Double          // 价格（美元）

    init(
        id: UUID = UUID(),
        brand: String,
        model: String,
        sizeLabel: String,
        stackMM: Double,
        reachMM: Double,
        priceAUD: Double
    ) {
        self.id = id
        self.brand = brand
        self.model = model
        self.sizeLabel = sizeLabel
        self.stackMM = stackMM
        self.reachMM = reachMM
        self.priceAUD = priceAUD
    }
}