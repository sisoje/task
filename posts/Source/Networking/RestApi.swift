import Foundation

struct RestApi {
    let session: URLSession
}

// MARK: - requesting raw data and decodable object

extension RestApi {
    @discardableResult
    func requestData(_ request: URLRequest, _ completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            if
                let error = error as NSError?,
                error.domain == NSURLErrorDomain,
                error.code == NSURLErrorCancelled {
                return
            }
            completion(
                Result {
                    try error.map {
                        throw $0
                    }
                    guard
                        let httpUrlResponse = response as? HTTPURLResponse,
                        httpUrlResponse.statusCode == 200,
                        let validData = data
                    else {
                        throw RequestError(request: request, data: data, response: response)
                    }
                    return validData
                }
            )
        }
        task.resume()
        return task
    }

    @discardableResult
    func requestObject<T: Decodable>(_ request: URLRequest, _ completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        requestData(request) { result in
            completion(
                result.flatMap { data in
                    Result {
                        try JSONDecoder().decode(T.self, from: data)
                    }
                }
            )
        }
    }
}

// MARK: - requesting posts and comments

extension RestApi {
    static let baseUrl = URL(string: "https://jsonplaceholder.typicode.com/")!

    @discardableResult
    func getPosts(userId: Int, _ completion: @escaping (Result<[Post], Error>) -> Void) -> URLSessionDataTask {
        let requestBuilder = URLRequestBuilder(Self.baseUrl)
        requestBuilder.GET()
        requestBuilder.acceptJson()
        requestBuilder.appendPathComponent("posts")
        requestBuilder.appendQuery(name: "userId", value: String(userId))
        return requestObject(requestBuilder.request, completion)
    }

    @discardableResult
    func getComments(postId: Int, _ completion: @escaping (Result<[Comment], Error>) -> Void) -> URLSessionDataTask {
        let requestBuilder = URLRequestBuilder(Self.baseUrl)
        requestBuilder.GET()
        requestBuilder.acceptJson()
        requestBuilder.appendPathComponent("comments")
        requestBuilder.appendQuery(name: "postId", value: String(postId))
        return requestObject(requestBuilder.request, completion)
    }
}

// MARK: - shared

extension RestApi {
    static let shared = RestApi(
        session: URLSession(
            configuration: .default,
            delegate: nil,
            delegateQueue: .main
        )
    )
}
