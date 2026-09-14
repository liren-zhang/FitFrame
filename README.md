# FitFrame — Data-Driven Bike Sizing

An iOS application that helps road cyclists find the correct frame size
based on body measurements, flexibility, and core strength — without the
cost of a professional bike fitting.

## Domain Context

The cycling industry uses inconsistent frame sizing charts across brands.
Two cyclists of the same height can require different frame sizes due to
differences in leg-to-torso ratio, arm length, flexibility, and core
strength. Professional bike fitting solves this problem, but costs
A$400–700 and takes several hours. FitFrame provides a data-driven,
accessible alternative.

## Project Overview

FitFrame takes six body measurements from the rider:
- Height, inseam, arm length, torso length (in cm)
- Flexibility score (1–5)
- Core strength score (1–5)

It then calculates the rider's target **Stack** and **Reach** using an
industry-standard formula, and matches those values against a database
of multi-brand road bike geometries (Aero, Climbing, All-Round,
Endurance categories).

## Architecture Summary

The project follows **MVVM + Use Case Layer**:
Views (SwiftUI)
↓
ViewModels (@ObservableObject)
↓
Use Cases (business rules)
↓
Domain Models + Repository

### Domain Models
- `CyclistBodyMeasurements` — the rider's six measurements
- `BicycleFrameGeometry` — a single frame size with Stack, Reach, price, category
- `FrameSizeRecommendation` — computed target Stack/Reach and matched frames
- `BikeModel` — a frame combined with its match quality
- `DomainError` — domain-specific error states

### Use Cases
- `CalculateStackReachUseCase` — converts body measurements into target geometry
- `MatchFrameSizeUseCase` — matches target values against the frame database
- `CompareBikeModelsUseCase` — compares two or three frames and recommends one

### Repository
- `BikeModelRepository` — provides the static multi-brand frame database

## Setup Instructions

1. Clone the repository:
git clone https://github.com/liren-zhang/FitFrame.git
2. Open `FitFrame.xcodeproj` in Xcode (version 16 or later).
3. Select an iOS Simulator (iPhone 15 Pro recommended).
4. Press `Cmd + R` to build and run.
5. Press `Cmd + U` to run the unit tests.

## Unit Tests

Eight unit tests cover the three Use Cases, including:
- Happy path for each Use Case
- Invalid input handling
- Boundary conditions (implausible inseam, empty frames, insufficient models)

Test names describe the domain scenario, e.g.
`calculateStackReach_returnsLowerStack_forAggressiveRider`.

## Git Workflow

Commits follow Conventional Commits format:
- `feat:` — new feature
- `fix:` — bug fix
- `docs:` — documentation
- `test:` — tests

## Future Work

- Core Data persistence for saved rider profiles
- CloudKit sync across devices
- Integration with live retailer inventory
- Support for gravel and mountain bike geometry

## GitHub Repository

[https://github.com/liren-zhang/FitFrame](https://github.com/liren-zhang/FitFrame)

---

*Project completed for Advanced iOS Development, UTS, September 2026.*