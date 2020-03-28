import Foundation

final class URLRequestBuilder {
    private(set) var request: URLRequest

    init(_ url: URL) {
        self.request = URLRequest(url: url)
    }
}

extension URLRequestBuilder {
    func appendPathComponent(_ path: String) {
        request.url?.appendPathComponent(path)
    }

    func appendQuery(name: String, value: String) {
        var comp = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
        comp.queryItems = (comp.queryItems ?? []) + [URLQueryItem(name: name, value: value)]
        request.url = comp.url
    }

    func GET() {
        request.httpMethod = "GET"
    }

    func acceptJson() {
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    }
}
