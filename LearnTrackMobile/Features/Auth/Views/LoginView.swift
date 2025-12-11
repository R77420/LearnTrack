import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isShowingResetAlert = false
    @State private var resetEmail = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                // Logo or Title
                Image(systemName: "graduationcap.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.blue)
                
                Text("LearnTrackMobile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Gestion de formations")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                // Form
                VStack(spacing: 15) {
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        #endif
                    
                    SecureField("Mot de passe", text: $viewModel.password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    HStack {
                        Spacer()
                        Button("Mot de passe oublié ?") {
                            resetEmail = viewModel.email
                            isShowingResetAlert = true
                        }
                        .font(.caption)
                        .foregroundStyle(.blue)
                    }
                }
                .padding(.horizontal)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                if let resetMessage = viewModel.resetMessage {
                    Text(resetMessage)
                        .foregroundStyle(.green)
                        .font(.caption)
                }
                
                Button(action: {
                    Task {
                        await viewModel.login()
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Se connecter")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(viewModel.isLoading)
                
                NavigationLink(destination: RegisterView()) {
                    Text("Pas encore de compte ? S'inscrire")
                        .font(.footnote)
                        .foregroundStyle(.blue)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Connexion")
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
            .alert("Réinitialiser le mot de passe", isPresented: $isShowingResetAlert) {
                TextField("Email", text: $resetEmail)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    #endif
                Button("Envoyer", action: {
                    Task {
                        await viewModel.resetPassword(for: resetEmail)
                    }
                })
                Button("Annuler", role: .cancel) { }
            } message: {
                Text("Entrez votre adresse email pour recevoir un lien de réinitialisation.")
            }
        }
    }
}

#Preview {
    LoginView()
}
