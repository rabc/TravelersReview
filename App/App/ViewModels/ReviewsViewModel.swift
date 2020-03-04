import Foundation
import AppServices
import RxSwift

class ReviewsViewModel {
    private let id: Int
    private var offset: OffsetParameter
    private let limit: LimitParameter
    private let service: ActivitiesServicesProtocol
    
    private var reviews = [Review]()
    
    required init(id: Int = 23776, offset: Int = 0, limit: Int = 50, service: ActivitiesServicesProtocol = ActivitiesServices()) {
        self.id = id
        self.offset = OffsetParameter(offset: offset)
        self.limit = LimitParameter(limit: limit)
        self.service = service
    }
    
    func loadData() -> Completable {
        return load()
    }
    
    func loadNextPage() -> Completable {
        offset = OffsetParameter(offset: offset.offset + limit.limit)
        return load()
    }
    
    private func load() -> Completable {
        return service.reviews(id: id, limit: limit, offset: offset)
            .map { [weak self] in
                self?.reviews.append(contentsOf: $0.reviews)
        }.asCompletable()
    }
}

extension ReviewsViewModel {
    func numberOfItems() -> Int {
        return reviews.count
    }
    
    func review(at row: Int) -> Review? {
        return reviews[safe: row]
    }
}
