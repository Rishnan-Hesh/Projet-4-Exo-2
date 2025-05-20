@testable import UserList

struct Name: Equatable {
    let title, first, last: String
}
struct DOB: Equatable {
    let date: String
}
struct Picture: Equatable {
    let thumbnail, medium, large: String
}

struct User: Identifiable, Equatable {
    let id: String
    let name: Name
    let dob: DOB
    let picture: Picture
}
