import XCTest
@testable import UserList

final class UserViewModelTests: XCTestCase {

    // Mock repository
    class MockUserListRepository: UserListRepository {
        var shouldReturnError = false
        var fetchCount = 0

        override func fetchUsers(quantity: Int) async throws -> [User] {
            fetchCount += 1
            if shouldReturnError {
                throw URLError(.badServerResponse)
            } else {
                return (1...quantity).map { i in
                    User.mock(id: "\(i)")
                }
            }
        }
    }

    func testInitialState() {
        let viewModel = UserViewModel(repository: MockUserListRepository())
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isGridView)
    }

    func testFetchUsersSuccess() async {
        let mockRepo = MockUserListRepository()
        let viewModel = UserViewModel(repository: mockRepo)

        await viewModel.fetchUsers()

        XCTAssertEqual(viewModel.users.count, 20)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testReloadUsersShouldClearAndFetch() async {
        let mockRepo = MockUserListRepository()
        let viewModel = UserViewModel(repository: mockRepo)

        await viewModel.fetchUsers()
        XCTAssertEqual(viewModel.users.count, 20)

        await viewModel.reloadUsers()
        XCTAssertEqual(viewModel.users.count, 20) // Should not be 40
        XCTAssertEqual(mockRepo.fetchCount, 2)
    }

    func testShouldLoadMoreData() async {
        let mockRepo = MockUserListRepository()
        let viewModel = UserViewModel(repository: mockRepo)

        await viewModel.fetchUsers()
        guard let last = viewModel.users.last else {
            XCTFail("Users list is empty")
            return
        }

        let shouldLoad = await viewModel.shouldLoadMoreData(currentItem: last)
        XCTAssertTrue(shouldLoad)

        let notLast = viewModel.users.first!
        let shouldNotLoad = await viewModel.shouldLoadMoreData(currentItem: notLast)
        XCTAssertFalse(shouldNotLoad)
    }

    func testFetchUsersFailure() async {
        let mockRepo = MockUserListRepository()
        mockRepo.shouldReturnError = true
        let viewModel = UserViewModel(repository: mockRepo)

        await viewModel.fetchUsers()

        XCTAssertTrue(viewModel.users.isEmpty)
        // We cannot test `isLoading` is reset because it's inside `Task {}` block without delay/wait
    }
}

// Extension to help create mock users
extension User {
    static func mock(id: String) -> User {
        return User(
            id: id,
            name: Name(title: "Mr", first: "John", last: "Doe"),
            dob: DOB(date: "1990-01-01"),
            picture: Picture(thumbnail: "", medium: "", large: "")
        )
    }
}
