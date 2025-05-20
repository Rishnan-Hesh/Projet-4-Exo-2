import Foundation

struct User: Identifiable {
    var id: String
    let name: Name
    let dob: Dob
    let picture: Picture


    // MARK: - Init
    init(user: UserListResponse.User) {
        self.id = UUID().uuidString
        self.name = .init(title: user.name.title, first: user.name.first, last: user.name.last)
        self.dob = .init(date: user.dob.date, age: user.dob.age)
        self.picture = .init(large: user.picture.large, medium: user.picture.medium, thumbnail: user.picture.thumbnail)
    }

    // MARK: - Dob
    struct Dob: Codable {
        let date: String
        let age: Int
    }

    // MARK: - Name
    struct Name: Codable {
        let title, first, last: String
    }

    // MARK: - Picture
    struct Picture: Codable {
        let large, medium, thumbnail: String
    }
}

extension User {
    init(from dto: UserListResponse.User, id: String = UUID().uuidString) {
        self.id = id
        self.name = Name(
            title: dto.name.title,
            first: dto.name.first,
            last: dto.name.last
        )
        self.dob = Dob(date: dto.dob.date, age: dto.dob.age)
        self.picture = Picture(
            large: dto.picture.large,
            medium: dto.picture.medium,
            thumbnail: dto.picture.thumbnail
        )
    }
}

