import Foundation
import RxSwift
import os

public enum RequestError: Error {
    case malformedParameters
    case malformedResponse(error: Error?)
    case serverError(status: Int, error: Error?)
    case requestError(error: Error)
}

class RequestManager {
    
    /// Singleton to use with this class
    static let shared = RequestManager()
    
    private let decoder: JSONDecoder
    private var session: URLSession
    
    private let timeout: TimeInterval = 60.0
    private let bag = DisposeBag()
    
    init(session: URLSession = URLSession(configuration: RequestManager.sessionConfiguration())) {
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        
        self.session = session
    }
    
    private static func sessionConfiguration() -> URLSessionConfiguration {
        
        var headers: [String: String] = [:]
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            headers["X-App-Version"] = "iOS/\(version)"
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        
        return configuration
    }
    
    /// Make an HTTP request
    /// - Parameter route: `RouterManagerConvertible` with endpoint to call
    /// - Parameter parameters: Parameter to use in case of GET request. Defauls to empty.
    func make<T: Decodable>(route: RouterManagerConvertible, parameters: [QueryConvertible] = []) -> Single<T> {
        return Single<T>.create { single in
            
            let routeManager = route.asRouter()
            var url = routeManager.asURL()
            
            if parameters.count > 0 && routeManager.method == .get {
                let queryString = self.buildQueryString(parameters: parameters)
                    .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPercentEncoding)!
                url = URL(string: url.absoluteString.appending("?\(queryString)"))!
            }
            
            os_log("Loading URL %@", url.absoluteString)
            let request = self.buildRequest(url: url, routeManager: routeManager)
            
            let task = self.session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    os_log("Error on communication: %@", String(describing: error))
                    single(.error(RequestError.serverError(status: 0, error: error)))
                    return
                }
                
                guard let data = data else {
                    os_log("Error on communication: %@", String(describing: error))
                    single(.error(RequestError.serverError(status: httpResponse.statusCode, error: error)))
                    return
                }
                
                guard httpResponse.isSuccess else {
                    os_log("Error on response: [%ld] %@", httpResponse.statusCode, String(describing: error))
                    single(.error(RequestError.serverError(status: httpResponse.statusCode, error: nil)))
                    return
                }
                
                do {
                    let obj = try self.decoder.decode(T.self, from: data)
                    os_log("Sending success response")
                    single(.success(obj))
                } catch (let decodeError) {
                    os_log("Error on decode: %@", String(describing: decodeError))
                    single(.error(RequestError.malformedResponse(error: decodeError)))
                }
            })
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
}

extension RequestManager {
    private func buildQueryString(parameters: [QueryConvertible]) -> String {
        
        let queryItems: [URLQueryItem] = parameters.compactMap { $0.queryItems() }
            .reduce([]) { $0 + $1 }
        
        var parametersStr: String = ""
        for item in queryItems {
            guard let value = item.value else { continue }
            
            if parametersStr != "" {
                parametersStr.append("&")
            }
            
            parametersStr.append("\(item.name)=\(value)")
        }
        
        return parametersStr
    }
    
    private func buildRequest(url: URL, routeManager: RouterManager) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: self.timeout)
        request.addValue(routeManager.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        request.httpMethod = routeManager.method.rawValue
        
        return request
    }
}
