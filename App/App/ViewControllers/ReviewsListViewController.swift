import UIKit
import RxSwift

class ReviewsListViewController: UIViewController {
    
    let viewModel: ReviewsViewModel
    
    private let bag = DisposeBag()
    
    lazy var loadingOverlay: UIView = UIView.loadingOverlay(frame: self.view.frame)
    
    // - MARK: UI elements
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    required init(viewModel: ReviewsViewModel = ReviewsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        setupTableView()
        
        loadData()
    }
    
    func loadData(next: Bool = false) {
        let response: Completable
        if next {
            response = viewModel.loadNextPage()
        } else {
            self.view.addSubview(loadingOverlay)
            response = viewModel.loadData()
        }
        
        response
            .observeOn(MainScheduler.instance)
            .subscribe(onCompleted: { [weak self] in
                self?.loadingOverlay.removeFromSuperview()
                self?.tableView.reloadData()
            }, onError: self.displayLoadError)
        .disposed(by: bag)
    }
    
}

// - MARK: Private methods
extension ReviewsListViewController {
    
    private func displayLoadError(error: Error) {
        loadingOverlay.removeFromSuperview()
        
        let alert = UIAlertController.singleButtonAlert(message: "Error on listing reviews. Please, try again.")
        present(alert, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.pinAnchors([.top, .leading, .trailing, .bottom], to: self.view)
        tableView.registerNibForReuse(cell: ListTableViewCell.self)
    }

}

extension ReviewsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.numberOfItems() - 1) {
            loadData(next: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? ListTableViewCell else {
                                                        assertionFailure("Wrong list cell")
                                                        return UITableViewCell()
        }
        
        if let review = viewModel.review(at: indexPath.row) {
            cell.setup(with: review)
        }
        
        return cell
    }
    

}
