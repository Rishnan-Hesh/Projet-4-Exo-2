//
//  UserViewModel.swift
//  UserList
//
//  Created by Johan Trino on 09/05/2025.
//

import Foundation

class UserViewModel: ObservableObject {
    
    private let repository: UserListRepository
    
    init(repository: UserListRepository = .init()) {
        self.repository = repository
    }
    
    // --- Outputs ---
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var isGridView = false
    
    // --- Inputs ---
   
    /// Fonction pour récupérer des utilisateurs.
    @MainActor
    func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                self.users.append(contentsOf: users)
                isLoading = false
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func fetchInitialUsersIfNeeded() {
        guard users.isEmpty else { return }
        fetchUsers()
    }
    
    /// Recharge la liste des utilisateurs.
    @MainActor
    func reloadUsers() {
        users.removeAll()
        fetchUsers()
    }
    
    /// Vérifie si l'élément actuel est le dernier et lance le chargement si nécessaire.
    @MainActor
    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }
}
