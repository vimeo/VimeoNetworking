import Foundation

public struct Video: Codable {
    let uri: String?

    public init(uri: String? = nil) {
        self.uri = uri
    }
}

public struct StaffPicks: Codable {
    public let data: [Video]
}
