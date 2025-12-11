import SwiftUI

struct Badge: View {
    let text: String
    var color: Color = .blue
    
    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .foregroundStyle(color)
            .cornerRadius(8)
    }
}
