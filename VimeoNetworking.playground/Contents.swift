

/*:
 Important: to use this Playground:
 1. Open the VimeoNetworking workspace
 2. Build VimeoNetworking-iOS scheme
 3. There is no third step!
 */

import UIKit
import VimeoNetworking
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let vimeoClient = makeVimeoClient()
let authenticationController = makeAuthenticationController(using: vimeoClient)

enum VideoEndpoint: EndpointType {

    case fetch(id: String)
    case fetchStaffPicks
    case create(Video)

    var headers: HTTPHeaders? { return nil }

    var path: String {
        switch self {
        case .fetch(let id):
            return "/videos/\(id)"
        case .fetchStaffPicks:
            return "/channels/staffpicks/videos"
        case .create:
            return "/videos"
        }
    }

    var parameters: Any? {
        switch self {
        case .create(let video):
            do {
                let data = try JSONEncoder().encode(video)
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                return nil
            }
        default:
            return nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetch, .fetchStaffPicks:
            return .get
        case .create:
            return .post
        }
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: VimeoBaseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        switch self {
        case .create:
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .fetch, .fetchStaffPicks:
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }

}

func performRequest(then callback: @escaping (Result<[Video], Error>) -> Void) {
    let video = VideoEndpoint.create(Video())
    vimeoClient.request(video) { (result: Result<StaffPicks, Error>) in
        switch result {
        case .success(let staffpicks):
            callback(Result.success(staffpicks.data))
        case .failure(let error):
            callback(Result.failure(error))
        }
    }
    
}

authenticationController.accessToken(token: token) { result in
    switch result {
        case .success(let account):
            print("authenticated successfully: \(account)")
            performRequest(then: { print($0) })
        case .failure(let error):
           print("failure authenticating: \(error)")
           performRequest(then: { print($0) })
    }
}
