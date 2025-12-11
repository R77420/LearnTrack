import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var nom = ""
    @State private var prenom = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Prénom", text: $prenom)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                TextField("Nom", text: $nom)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                SecureField("Mot de passe", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                SecureField("Confirmer le mot de passe", text: $confirmPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                Button(action: register) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("S'inscrire")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundStyle(.white)
                .cornerRadius(10)
                .disabled(isLoading)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Inscription")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func register() {
        guard !email.isEmpty, !password.isEmpty, !nom.isEmpty, !prenom.isEmpty else {
            errorMessage = "Veuillez remplir tous les champs"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Les mots de passe ne correspondent pas"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await APIService.shared.register(email: email, password: password, nom: nom, prenom: prenom)
                if response.success {
                    dismiss()
                } else {
                    errorMessage = response.message
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
