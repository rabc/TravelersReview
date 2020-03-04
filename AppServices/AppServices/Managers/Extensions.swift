import Foundation

extension CharacterSet {
    static var urlPercentEncoding: CharacterSet {
        var urlCharsAllowed = CharacterSet.urlHostAllowed
        urlCharsAllowed.subtract(CharacterSet(charactersIn: "+"))
        
        return urlCharsAllowed
    }
}

enum HTTPStatusCodes: Int {
    case Created = 201
    case Accepted = 202
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case InternalServerError = 500
    case NotImplemented = 501
    case BadGateway = 502
    case ServiceUnavailable = 503
    
    static func validStatus() -> Range<Int> {
        return 200..<300
    }
}

extension HTTPURLResponse {
    
    /// Check if the status code is between the valid code (200-299)
    ///
    /// - Returns: Bool
    var isSuccess: Bool {
        // Check status code is valid
        if HTTPStatusCodes.validStatus() ~= self.statusCode {
            return true
        }
        
        return false
    }
}

