import SwiftUI

struct UserListView: View {
    let repository: UserListRepositoryProtocol = UserListRepository()
    @StateObject var viewModel: UserListViewModel // On observe ce qu'il se passe dans ce fichier ViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isGridView {
                    gridView()
                } else {
                    listView()
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PickerView(
                        isGridView: $viewModel.isGridView,
                        imageTrue: Image(systemName: "rectangle.grid.1x2.fill"),
                        imageFalse: Image(systemName: "list.bullet"),
                        labelTrue: "Grille",
                        labelFalse: "Liste"
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.reloadUsers()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchUsers()
            }
        }
    }

    
    @ViewBuilder
    private func listView() -> some View {
        List(viewModel.users) { user in
            NavigationLink(destination: UserDetailView(user: user)) {
                HStack {
                    AvatarView(url: user.picture.medium, size: CGSize(width: 50, height: 50))

                    VStack(alignment: .leading) {
                        Text("\(user.name.first) \(user.name.last)")
                            .font(.headline)
                        Text("\(user.dob.date)")
                            .font(.subheadline)
                    }
                }
            }
            .onAppear {
                Task {
                    if viewModel.shouldLoadMoreData(currentItem: user) {
                        await viewModel.fetchUsers()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func gridView() -> some View {
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
                        Task {
                            if viewModel.shouldLoadMoreData(currentItem: user) {
                                await viewModel.fetchUsers()
                            }
                        }
                    }
                }
            }
        }
    }

    
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(viewModel: UserListViewModel(repository: UserListRepository()))
    }
}

