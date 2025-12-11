import Foundation
import SwiftUI
import Combine

@MainActor
class FormateurViewModel: ObservableObject {
    @Published var formateurs: [Formateur] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchFormateurs() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedFormateurs = try await APIService.shared.getFormateurs()
            self.formateurs = fetchedFormateurs
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
