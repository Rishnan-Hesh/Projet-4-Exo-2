import SwiftUI

struct UserDetailView: View {
    let user: User
    
    var body: some View {
        VStack {
            AvatarView(url: user.picture.large, size: CGSize(width: 200, height: 200))
            
            VStack(alignment: .leading) {
                Text("\(user.name.first) \(user.name.last)")
                    .font(.headline)
                Text("\(user.dob.date)")
                    .font(.subheadline)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("\(user.name.first) \(user.name.last)")
    }
}
