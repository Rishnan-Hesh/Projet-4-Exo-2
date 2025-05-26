import Foundation
import SwiftUI

struct AvatarView: View {
    
    private let url: String
    private let size: CGSize
    
    init(url: String, size: CGSize) {
        self.url = url
        self.size = size
    }
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
                .frame(width: size.width, height: size.height)
                .clipShape(Circle())
        }
    }
    
    
}
