import Foundation
import SwiftUI
import Combine

@MainActor
class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchClients() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedClients = try await APIService.shared.getClients()
            self.clients = fetchedClients
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
