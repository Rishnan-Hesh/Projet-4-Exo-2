import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if !viewModel.isGridView {
                    List(viewModel.users) { user in
                        NavigationLink(destination: UserDetailView(user: user)) {
                            HStack {
                                AvatarView(url: user.picture.thumbnail, size: CGSize(width: 50, height: 50))
                                
                                VStack(alignment: .leading) {
                                    Text("\(user.name.first) \(user.name.last)")
                                        .font(.headline)
                                    Text("\(user.dob.date)")
                                        .font(.subheadline)
                                }
                            }
                        }
                        .onAppear {
                            if self.viewModel.shouldLoadMoreData(currentItem: user) {
                                self.viewModel.fetchUsers()
                            }
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                            ForEach(viewModel.users) { user in
                                NavigationLink(destination: UserDetailView(user: user)) {
                                    VStack {
                                        AvatarView(url: user.picture.medium, size: CGSize(width: 150, height: 150))
                                        
                                        Text("\(user.name.first) \(user.name.last)")
                                            .font(.headline)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .onAppear {
                                    if self.viewModel.shouldLoadMoreData(currentItem: user) {
                                        self.viewModel.fetchUsers()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    PickerView(
                        isGridView: $viewModel.isGridView,
                        imageTrue: Image(systemName: "rectangle.grid.1x2.fill"),
                        imageFalse: Image(systemName: "list.bullet"),
                        labelTrue: "Grille",
                        labelFalse: "Liste"
                    )

                    Button(action: {
                        viewModel.reloadUsers()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                    }
                }
            }
        }
        .onAppear {
            self.viewModel.fetchUsers()
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
