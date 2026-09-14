//
//  BikeModelRepository.swift
//  FitFrame
//
//  Created by Liren Zhang on 11/9/2026.
//

//
//  BikeModelRepository.swift
//  FitFrame
//
//  Static multi-brand road bike frame database.
//

import Foundation

/// Provides the built-in database of road bike frame geometries.
///
/// This repository is the single source of frame data used by
/// `MatchFrameSizeUseCase`. The data covers multiple brands and models,
/// each with several sizes so that a wide range of rider proportions can
/// be matched.
///
/// - Note: All prices are in Australian Dollars (AUD).
/// - Important: The data is static and bundled with the app. In a future
///   version this repository would be replaced by a network-backed
///   implementation without changing any of its callers.
struct BikeModelRepository {

    /// Returns every frame in the repository.
    ///
    /// - Returns: An array of `BicycleFrameGeometry` values.
    /// - Throws: This method does not currently throw, but the signature
    ///   allows future implementations to fail if data cannot be loaded.
    func loadAllFrames() throws -> [BicycleFrameGeometry] {
        return allFrames
    }

    /// Returns all frames that belong to a given brand.
    ///
    /// - Parameter brand: The brand name, e.g. `"Canyon"`.
    /// - Returns: All matching frames, or an empty array if the brand is unknown.
    func frames(forBrand brand: String) -> [BicycleFrameGeometry] {
        return allFrames.filter { $0.brand == brand }
    }

    // MARK: - Built-in data

    /// The complete frame database.
    private var allFrames: [BicycleFrameGeometry] {
        return [
            // ───── Giant Propel Advanced SL ─────
            BicycleFrameGeometry(brand: "Giant", model: "Propel Advanced SL", sizeLabel: "XS",
                                 stackMM: 517, reachMM: 376, priceAUD: 12999),
            BicycleFrameGeometry(brand: "Giant", model: "Propel Advanced SL", sizeLabel: "S",
                                 stackMM: 528, reachMM: 383, priceAUD: 12999),
            BicycleFrameGeometry(brand: "Giant", model: "Propel Advanced SL", sizeLabel: "M",
                                 stackMM: 545, reachMM: 388, priceAUD: 12999),
            BicycleFrameGeometry(brand: "Giant", model: "Propel Advanced SL", sizeLabel: "ML",
                                 stackMM: 562, reachMM: 393, priceAUD: 12999),
            BicycleFrameGeometry(brand: "Giant", model: "Propel Advanced SL", sizeLabel: "L",
                                 stackMM: 581, reachMM: 402, priceAUD: 12999),
            BicycleFrameGeometry(brand: "Giant", model: "Propel Advanced SL", sizeLabel: "XL",
                                 stackMM: 596, reachMM: 412, priceAUD: 12999),

            // ───── Giant TCR Advanced SL ─────
            BicycleFrameGeometry(brand: "Giant", model: "TCR Advanced SL", sizeLabel: "XS",
                                 stackMM: 517, reachMM: 376, priceAUD: 11999),
            BicycleFrameGeometry(brand: "Giant", model: "TCR Advanced SL", sizeLabel: "S",
                                 stackMM: 528, reachMM: 383, priceAUD: 11999),
            BicycleFrameGeometry(brand: "Giant", model: "TCR Advanced SL", sizeLabel: "M",
                                 stackMM: 545, reachMM: 388, priceAUD: 11999),
            BicycleFrameGeometry(brand: "Giant", model: "TCR Advanced SL", sizeLabel: "ML",
                                 stackMM: 562, reachMM: 393, priceAUD: 11999),
            BicycleFrameGeometry(brand: "Giant", model: "TCR Advanced SL", sizeLabel: "L",
                                 stackMM: 581, reachMM: 402, priceAUD: 11999),
            BicycleFrameGeometry(brand: "Giant", model: "TCR Advanced SL", sizeLabel: "XL",
                                 stackMM: 596, reachMM: 412, priceAUD: 11999),

            // ───── Canyon Aeroad CFR ─────
            BicycleFrameGeometry(brand: "Canyon", model: "Aeroad CFR", sizeLabel: "2XS",
                                 stackMM: 498, reachMM: 372, priceAUD: 15999),
            BicycleFrameGeometry(brand: "Canyon", model: "Aeroad CFR", sizeLabel: "XS",
                                 stackMM: 520, reachMM: 378, priceAUD: 15999),
            BicycleFrameGeometry(brand: "Canyon", model: "Aeroad CFR", sizeLabel: "S",
                                 stackMM: 539, reachMM: 390, priceAUD: 15999),
            BicycleFrameGeometry(brand: "Canyon", model: "Aeroad CFR", sizeLabel: "M",
                                 stackMM: 560, reachMM: 393, priceAUD: 15999),
            BicycleFrameGeometry(brand: "Canyon", model: "Aeroad CFR", sizeLabel: "L",
                                 stackMM: 580, reachMM: 401, priceAUD: 15999),
            BicycleFrameGeometry(brand: "Canyon", model: "Aeroad CFR", sizeLabel: "XL",
                                 stackMM: 606, reachMM: 419, priceAUD: 15999),
            BicycleFrameGeometry(brand: "Canyon", model: "Aeroad CFR", sizeLabel: "2XL",
                                 stackMM: 624, reachMM: 429, priceAUD: 15999),

            // ───── Specialized Tarmac SL9 ─────
            BicycleFrameGeometry(brand: "Specialized", model: "Tarmac SL9", sizeLabel: "49",
                                 stackMM: 501, reachMM: 366, priceAUD: 14999),
            BicycleFrameGeometry(brand: "Specialized", model: "Tarmac SL9", sizeLabel: "52",
                                 stackMM: 514, reachMM: 375, priceAUD: 14999),
            BicycleFrameGeometry(brand: "Specialized", model: "Tarmac SL9", sizeLabel: "54",
                                 stackMM: 527, reachMM: 380, priceAUD: 14999),
            BicycleFrameGeometry(brand: "Specialized", model: "Tarmac SL9", sizeLabel: "56",
                                 stackMM: 544, reachMM: 384, priceAUD: 14999),
            BicycleFrameGeometry(brand: "Specialized", model: "Tarmac SL9", sizeLabel: "58",
                                 stackMM: 565, reachMM: 395, priceAUD: 14999),
            BicycleFrameGeometry(brand: "Specialized", model: "Tarmac SL9", sizeLabel: "61",
                                 stackMM: 591, reachMM: 402, priceAUD: 14999),

            // ───── Trek Madone Gen 8 ─────
            BicycleFrameGeometry(brand: "Trek", model: "Madone Gen 8", sizeLabel: "XS",
                                 stackMM: 507, reachMM: 370, priceAUD: 13999),
            BicycleFrameGeometry(brand: "Trek", model: "Madone Gen 8", sizeLabel: "S",
                                 stackMM: 530, reachMM: 378, priceAUD: 13999),
            BicycleFrameGeometry(brand: "Trek", model: "Madone Gen 8", sizeLabel: "M",
                                 stackMM: 546, reachMM: 383, priceAUD: 13999),
            BicycleFrameGeometry(brand: "Trek", model: "Madone Gen 8", sizeLabel: "ML",
                                 stackMM: 562, reachMM: 389, priceAUD: 13999),
            BicycleFrameGeometry(brand: "Trek", model: "Madone Gen 8", sizeLabel: "L",
                                 stackMM: 578, reachMM: 394, priceAUD: 13999),

            // ───── Specialized Roubaix SL8 ─────
            BicycleFrameGeometry(brand: "Specialized", model: "Roubaix SL8", sizeLabel: "49",
                                 stackMM: 549, reachMM: 363, priceAUD: 10999),
            BicycleFrameGeometry(brand: "Specialized", model: "Roubaix SL8", sizeLabel: "52",
                                 stackMM: 566, reachMM: 370, priceAUD: 10999),
            BicycleFrameGeometry(brand: "Specialized", model: "Roubaix SL8", sizeLabel: "54",
                                 stackMM: 585, reachMM: 381, priceAUD: 10999),
            BicycleFrameGeometry(brand: "Specialized", model: "Roubaix SL8", sizeLabel: "56",
                                 stackMM: 605, reachMM: 389, priceAUD: 10999),
            BicycleFrameGeometry(brand: "Specialized", model: "Roubaix SL8", sizeLabel: "58",
                                 stackMM: 630, reachMM: 397, priceAUD: 10999),

            // ───── Canyon Endurace CFR ─────
            BicycleFrameGeometry(brand: "Canyon", model: "Endurace CFR", sizeLabel: "XS",
                                 stackMM: 532, reachMM: 370, priceAUD: 11999),
            BicycleFrameGeometry(brand: "Canyon", model: "Endurace CFR", sizeLabel: "S",
                                 stackMM: 552, reachMM: 378, priceAUD: 11999),
            BicycleFrameGeometry(brand: "Canyon", model: "Endurace CFR", sizeLabel: "M",
                                 stackMM: 565, reachMM: 389, priceAUD: 11999),
            BicycleFrameGeometry(brand: "Canyon", model: "Endurace CFR", sizeLabel: "L",
                                 stackMM: 585, reachMM: 398, priceAUD: 11999),

            // ───── Giant Defy Advanced SL ─────
            BicycleFrameGeometry(brand: "Giant", model: "Defy Advanced SL", sizeLabel: "XS",
                                 stackMM: 527, reachMM: 369, priceAUD: 9499),
            BicycleFrameGeometry(brand: "Giant", model: "Defy Advanced SL", sizeLabel: "S",
                                 stackMM: 541, reachMM: 375, priceAUD: 9499),
            BicycleFrameGeometry(brand: "Giant", model: "Defy Advanced SL", sizeLabel: "M",
                                 stackMM: 558, reachMM: 380, priceAUD: 9499),
            BicycleFrameGeometry(brand: "Giant", model: "Defy Advanced SL", sizeLabel: "ML",
                                 stackMM: 577, reachMM: 384, priceAUD: 9499),
            BicycleFrameGeometry(brand: "Giant", model: "Defy Advanced SL", sizeLabel: "L",
                                 stackMM: 596, reachMM: 393, priceAUD: 9499),
            BicycleFrameGeometry(brand: "Giant", model: "Defy Advanced SL", sizeLabel: "XL",
                                 stackMM: 615, reachMM: 402, priceAUD: 9499),

            // ───── Cannondale SuperSix EVO ─────
            BicycleFrameGeometry(brand: "Cannondale", model: "SuperSix EVO", sizeLabel: "48",
                                 stackMM: 495, reachMM: 373, priceAUD: 12999),
            BicycleFrameGeometry(brand: "Cannondale", model: "SuperSix EVO", sizeLabel: "51",
                                 stackMM: 508, reachMM: 376, priceAUD: 12999),
            BicycleFrameGeometry(brand: "Cannondale", model: "SuperSix EVO", sizeLabel: "54",
                                 stackMM: 532, reachMM: 383, priceAUD: 12999),
            BicycleFrameGeometry(brand: "Cannondale", model: "SuperSix EVO", sizeLabel: "56",
                                 stackMM: 545, reachMM: 387, priceAUD: 12999),
            BicycleFrameGeometry(brand: "Cannondale", model: "SuperSix EVO", sizeLabel: "58",
                                 stackMM: 565, reachMM: 393, priceAUD: 12999),

            // ───── Pinarello Dogma F ─────
            BicycleFrameGeometry(brand: "Pinarello", model: "Dogma F", sizeLabel: "50",
                                 stackMM: 502, reachMM: 352, priceAUD: 17999),
            BicycleFrameGeometry(brand: "Pinarello", model: "Dogma F", sizeLabel: "53",
                                 stackMM: 525, reachMM: 372, priceAUD: 17999),
            BicycleFrameGeometry(brand: "Pinarello", model: "Dogma F", sizeLabel: "55",
                                 stackMM: 542, reachMM: 383, priceAUD: 17999),
            BicycleFrameGeometry(brand: "Pinarello", model: "Dogma F", sizeLabel: "57.5",
                                 stackMM: 584, reachMM: 397, priceAUD: 17999),
        ]
    }
}