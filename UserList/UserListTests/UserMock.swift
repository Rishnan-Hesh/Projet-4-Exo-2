@testable import UserList

struct Name { let title, first, last: String }
struct DOB { let date: String }
struct Picture { let thumbnail, medium, large: String }

struct User: Identifiable, Equatable {
    let id: String
    let name: Name
    let dob: DOB
    let picture: Picture

    static func mock(id: String) -> User {
        return User(
            id: id,
            name: Name(title: "Mr", first: "John", last: "Doe"),
            dob: DOB(date: "1990-01-01"),
            picture: Picture(thumbnail: "thumb.jpg", medium: "med.jpg", large: "large.jpg")
        )
    }
}
