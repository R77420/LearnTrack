//
//  AuthServiceTests.swift
//  LearnTrackMobileTests
//
//  Created by LearnTrack on 12/12/2025.
//

import XCTest
@testable import LearnTrackMobile

final class AuthServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Clear keychain to ensure fresh state
        KeychainManager.shared.delete(key: "auth_user")
    }
    
    override func tearDown() {
        KeychainManager.shared.delete(key: "auth_user")
        super.tearDown()
    }
    
    func testLoginUpdatesStateAndPersists() {
        // Given
        let authService = AuthService.shared
        let user = User(id: 1, email: "test@test.com", nom: "Tester", prenom: "Unit", role: "admin", actif: true)
        
        let expectation = XCTestExpectation(description: "Login updates state on MainActor")
        
        // When
        Task { @MainActor in
            authService.login(user: user)
            
            // Then
            XCTAssertTrue(authService.isAuthenticated)
            XCTAssertEqual(authService.currentUser?.email, "test@test.com")
            XCTAssertTrue(authService.isAdmin)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Verify persistence (Sync access to Keychain is fine)
        let storedData = KeychainManager.shared.load(key: "auth_user")
        XCTAssertNotNil(storedData, "User data should be persisted in Keychain")
    }
    
    func testLogoutClearsState() {
        // Given
        let authService = AuthService.shared
        let user = User(id: 2, email: "user@test.com", nom: "User", prenom: "Simple", role: "user", actif: true)
        
        let loginExp = XCTestExpectation(description: "Login")
        let logoutExp = XCTestExpectation(description: "Logout")
        
        Task { @MainActor in
            authService.login(user: user)
            loginExp.fulfill()
            
            // When
            authService.logout()
            
            // Then
            XCTAssertFalse(authService.isAuthenticated)
            XCTAssertNil(authService.currentUser)
            logoutExp.fulfill()
        }
        
        wait(for: [loginExp, logoutExp], timeout: 1.0)
        
        let storedData = KeychainManager.shared.load(key: "auth_user")
        XCTAssertNil(storedData, "User data should be removed from Keychain")
    }
}
