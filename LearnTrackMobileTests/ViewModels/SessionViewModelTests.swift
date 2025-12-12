//
//  SessionViewModelTests.swift
//  LearnTrackMobileTests
//
//  Created by LearnTrack on 12/12/2025.
//

import XCTest
@testable import LearnTrackMobile

@MainActor
final class SessionViewModelTests: XCTestCase {
    
    var viewModel: SessionViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SessionViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.sessions.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.clients.isEmpty)
        XCTAssertTrue(viewModel.formateurs.isEmpty)
        XCTAssertTrue(viewModel.ecoles.isEmpty)
    }
    
    // Note: Since SessionViewModel uses internal APIs that hit the network,
    // we cannot easily test fetchSessions() without mocking the network layer.
    // However, we can test that calling fetchDependencies triggers loading state changes
    // if we could inspect intermediate states, but normally we just wait for the result.
    
    func testFetchSessionsUpdatesLoadingState() async {
        // This test assumes network might fail or succeed, but checks basic async execution
        await viewModel.fetchSessions()
        
        // After fetch, loading should be false
        XCTAssertFalse(viewModel.isLoading)
        
        // Either sessions are populated OR errorMessage is set (if network fails)
        if viewModel.errorMessage != nil {
            XCTAssertTrue(viewModel.sessions.isEmpty) // Likely empty if error
        } else {
            // If no error, we might have sessions
            // Pass
        }
    }
}
