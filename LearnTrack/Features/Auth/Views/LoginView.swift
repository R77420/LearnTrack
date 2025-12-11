import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
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
                
                Text("LearnTrack")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Gestion de formations")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                // Form
                VStack(spacing: 15) {
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    SecureField("Mot de passe", text: $viewModel.password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
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
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LoginView()
}
