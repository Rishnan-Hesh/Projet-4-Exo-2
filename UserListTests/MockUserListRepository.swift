import Foundation

final class MockUserListRepository {

    static func successMock(users: [User]) -> UserListRepository {
        let response = UserListResponse(results: users.map { user in
            UserListResponse.User(
                name: .init(title: user.name.title, first: user.name.first, last: user.name.last),
                dob: .init(date: user.dob.date, age: 30),
                picture: .init(
                    large: user.picture.large,
                    medium: user.picture.medium,
                    thumbnail: user.picture.thumbnail
                )
            )
        })

        let data = try! JSONEncoder().encode(response)

        return UserListRepository(executeDataRequest: { _ in
            return (data, URLResponse())
        })
    }

    static func errorMock() -> UserListRepository {
        return UserListRepository(executeDataRequest: { _ in
            throw URLError(.badServerResponse)
        })
    }
}
