import Foundation
import SwiftUI
import Combine

@MainActor
class EcoleViewModel: ObservableObject {
    @Published var ecoles: [Ecole] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchEcoles() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedEcoles = try await APIService.shared.getEcoles()
            self.ecoles = fetchedEcoles
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
