import SwiftUI

struct MapsLink: View {
    let address: String
    
    var body: some View {
        Button(action: {
            let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string: "http://maps.apple.com/?q=\(encodedAddress)") {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                Image(systemName: "map")
                Text(address)
                    .multilineTextAlignment(.leading)
            }
            .font(.subheadline)
            .foregroundStyle(.blue)
        }
    }
}
