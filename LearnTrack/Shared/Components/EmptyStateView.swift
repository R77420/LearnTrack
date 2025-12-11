import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let message: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundStyle(.secondary)
            Text(message)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}
