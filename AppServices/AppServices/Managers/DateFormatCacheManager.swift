import Foundation

public struct DateFormatCacheManager {
    
    public static let shared = DateFormatCacheManager()
    
    public let shortDateStyle: DateFormatter
    
    public init() {
        self.shortDateStyle = DateFormatter()
        self.shortDateStyle.dateStyle = .short
        self.shortDateStyle.timeStyle = .none
    }
}
