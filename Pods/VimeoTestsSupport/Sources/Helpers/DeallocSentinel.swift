//
//  DeallocSentinel.swift
//  VimeoTestsSupport
//
//  Created by Rogerio de Paula Assis on 7/16/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//
//  Extracted from this CCH Melbourne talk:
//  https://www.youtube.com/watch?v=514rJ1efv84
//

import XCTest

/// Example usage:
///
/// class ViewModel {
///     /* weak */ var vc: ViewController?
/// }
///
/// class ViewController: UIViewController {
///     let viewModel: ViewModel
///
///     init(viewModel :ViewModel) {
///         self.viewModel = viewModel
///         super.init(nibName: nil, bundle: nil)
///     }
///
///     required init?(coder aDecoder: NSCoder) {
///         fatalError("init(coder:) has not been implemented")
///     }
/// }
///
/// class DeallocTests: XCTestCase {
///
///     private var deallocationExpectations: [XCTestExpectation] = []
///     var subject: ViewModel!
///
///     override func setUp() {
///         subject = ViewModel()
///         let vc = ViewController(viewModel: subject)
///         subject.vc = vc
///         expectDeallocation(of: subject, using: deallocationExpectations)
///     }
///
///     override func tearDown() {
///         wait(for: self.deallocatioExpectations, timeout: 1)
///     }
///
///     func testDeallocation() {
///         XCTAssert(subject != nil)
///         subject = nil
///     }
/// }
///

public func expectDeallocation(
    of object: AnyObject,
    using deallocationExpectations: inout [XCTestExpectation]
) {
    let expectation = XCTestExpectation(description: "Object \(object) deallocated")
    objc_setAssociatedObject(
        object,
        &deallocatedExpectationKey,
        DeallocationSentinel(deallocClosure: expectation.fulfill),
        .OBJC_ASSOCIATION_RETAIN
    )
    deallocationExpectations.append(expectation)
}

// MARK: Private
private var deallocatedExpectationKey = 0
private final class DeallocationSentinel {
    
    private let deallocClosure: () -> Void
    
    init(deallocClosure: @escaping () -> Void) {
        self.deallocClosure = deallocClosure
    }
    
    deinit {
        deallocClosure()
    }
}
