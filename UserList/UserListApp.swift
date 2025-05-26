import SwiftUI

@main
struct UserListApp: App {
    var body: some Scene {
        WindowGroup {
            UserListView(viewModel: UserListViewModel(repository: UserListRepository()))
        }
    }
}
