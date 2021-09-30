import XCTest
@testable import LaserFocus

final class LaserFocusTests: XCTestCase {
  func testPrioritizedAtoms() throws {
    let inputs: [ActionableInput] = [
      .init(
        id: "A",
        localCategory: .vital,
        children: [
          .init(
            id: "A1",
            localCategory: .vital,
            children: [
              .init(id: "A1a", localCategory: .vital),
              .init(id: "A1b", localCategory: .essential),
              .init(id: "A1c", localCategory: .completing),
              .init(id: "A1d", localCategory: .optional),
              .init(id: "A1e", localCategory: .retracting),
            ]
          ),
          .init(
            id: "A2",
            localCategory: .essential,
            children: [
              .init(id: "A2a", localCategory: .vital),
              .init(id: "A2b", localCategory: .essential),
              .init(id: "A2c", localCategory: .completing),
              .init(id: "A2d", localCategory: .optional),
              .init(id: "A2e", localCategory: .retracting),
            ]
          ),
          .init(
            id: "A3",
            localCategory: .completing,
            children: [
              .init(id: "A3a", localCategory: .vital),
              .init(id: "A3b", localCategory: .essential),
              .init(id: "A3c", localCategory: .completing),
              .init(id: "A3d", localCategory: .optional),
              .init(id: "A3e", localCategory: .retracting),
            ]
          ),
          .init(
            id: "A4",
            localCategory: .optional,
            children: [
              .init(id: "A4a", localCategory: .vital),
              .init(id: "A4b", localCategory: .essential),
              .init(id: "A4c", localCategory: .completing),
              .init(id: "A4d", localCategory: .optional),
              .init(id: "A4e", localCategory: .retracting),
            ]
          ),
          .init(
            id: "A5",
            localCategory: .retracting,
            children: [
              .init(id: "A5a", localCategory: .vital),
              .init(id: "A5b", localCategory: .essential),
              .init(id: "A5c", localCategory: .completing),
              .init(id: "A5d", localCategory: .optional),
              .init(id: "A5e", localCategory: .retracting),
            ]
          ),
        ]
      ),
      .init(
        id: "B",
        localCategory: .optional,
        children: [
          .init(
            id: "B1",
            localCategory: .vital,
            children: [
              .init(id: "B1a", localCategory: .vital),
              .init(id: "B1b", localCategory: .essential),
              .init(id: "B1c", localCategory: .completing),
              .init(id: "B1d", localCategory: .optional),
              .init(id: "B1e", localCategory: .retracting),
            ]
          ),
          .init(
            id: "B2",
            localCategory: .essential,
            children: [
              .init(
                id: "B2a",
                localCategory: .vital,
                children: [
                  .init(id: "B2a1", localCategory: .completing)
                ]
              )
            ]
          )
        ]
      ),
      .init(id: "C", localCategory: .completing)
    ]

    let outputs = LaserFocus.prioritizedAtoms(inputs: inputs)
    XCTAssertEqual(outputs.count, 32)
    XCTAssertEqual(
      outputs.map(\.id),
      [
        "A1a", "A1b", "A1c", "A1d", "A1e",
        "A2a", "A2b", "A2c", "A2d", "A2e",
        "A3a", "A3b", "A3c", "A3d", "A3e",
        "A4a", "A4b", "A4c", "A4d", "A4e",
        "A5a", "A5b", "A5c", "A5d", "A5e",
        "B1a", "B1b", "B1c", "B1d", "B1e",
        "B2a1", "C"
      ]
    )
    XCTAssertEqual(
      outputs.map(\.globalCategory),
      [
        .vital, .essential, .completing, .optional, .retracting,
        .essential, .essential, .completing, .optional, .retracting,
        .completing, .completing, .completing, .optional, .retracting,
        .optional, .optional, .optional, .optional, .retracting,
        .retracting, .retracting, .retracting, .retracting, .retracting,
        .optional, .optional, .optional, .optional, .retracting,
        .optional, .completing
      ]
    )
    XCTAssertEqual(outputs.first { $0.id == "A1a" }!.averageCategoryRawValue, 1, accuracy: 0.001)
    XCTAssertEqual(outputs.first { $0.id == "A3c" }!.averageCategoryRawValue, 2.333, accuracy: 0.001)
    XCTAssertEqual(outputs.first { $0.id == "A5e" }!.averageCategoryRawValue, 3.666, accuracy: 0.001)
    XCTAssertEqual(outputs.first { $0.id == "A2b" }!.averageCategoryRawValue, 1.666, accuracy: 0.001)
    XCTAssertEqual(outputs.first { $0.id == "A4d" }!.averageCategoryRawValue, 3, accuracy: 0.001)
    XCTAssertEqual(outputs.first { $0.id == "B1c" }!.averageCategoryRawValue, 2.666, accuracy: 0.001)
    XCTAssertEqual(outputs.first { $0.id == "B2a1" }!.averageCategoryRawValue, 2.5, accuracy: 0.001)
    XCTAssertEqual(outputs.first { $0.id == "C" }!.averageCategoryRawValue, 3, accuracy: 0.001)
  }

  func testReadmeExample() {
    let inputs: [ActionableInput] = [
      .init(id: "A", localCategory: .vital, children: [
          .init(id: "A1", localCategory: .vital, children: [
              .init(id: "A1x", localCategory: .vital),
              .init(id: "A1y", localCategory: .essential),
              .init(id: "A1z", localCategory: .completing),
            ]
          ),
          .init(id: "A2", localCategory: .essential),
          .init(id: "A3", localCategory: .completing, children: [
              .init(id: "A3x", localCategory: .vital),
              .init(id: "A3y", localCategory: .essential),
              .init(id: "A3z", localCategory: .completing),
            ]
          ),
        ]
      ),
      .init(id: "B", localCategory: .optional, children: [
          .init(id: "B1", localCategory: .vital),
          .init(id: "B2", localCategory: .essential, children: [
              .init(id: "B2x", localCategory: .vital),
              .init(id: "B2y", localCategory: .retracting),
              .init(id: "B2z", localCategory: .completing),
            ]
          )
        ]
      ),
      .init(id: "C", localCategory: .completing)
    ]

    let sortedOutputs: [ActionableOutput] = LaserFocus.prioritizedAtoms(inputs: inputs).sorted()
    XCTAssertEqual(
      sortedOutputs.map(\.id),
      ["A1x", "A1y", "A2", "A1z", "A3x", "A3y", "A3z", "C", "B2x", "B1", "B2z", "B2y"]
    )
  }
}
