import Foundation
import SwiftUI
import Combine

@MainActor
class SessionViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchSessions() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedSessions = try await APIService.shared.getSessions()
            self.sessions = fetchedSessions
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
