//
//  GridViewController.swift
//  PhotoSearch
//
//  Created by bnulo on 5/21/22.
//

import UIKit
import Combine


class GridViewController: CompositionalCollectionViewViewController {

    var viewModel: CollectionViewModel
    private var subscriptions: Set<AnyCancellable> = []
    private var datasource: FlickrDiffableDataSource!
    fileprivate typealias PhotosSnaphot = NSDiffableDataSourceSnapshot<Int, CellViewModel>
    let collectionViewBottomContentInset: CGFloat = 50
    let loadingIndicatorBottomAnchor: CGFloat = 10
    let searchbarWidth: CGFloat = 240
    let searchbarHeight: CGFloat = 200

    enum GridItemSize: CGFloat {
        case whole = 1
        case half = 0.5
        case third = 0.33333
        case quarter = 0.25
    }
    var gridItemSize: GridItemSize = .half {
        didSet {
            collectionView.setCollectionViewLayout(createLayout(), animated: true)
        }
    }
    
    // MARK: - View
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var sizeMenu: UIMenu = { [unowned self] in
        return UIMenu(title: "Select size", image: nil, identifier: nil, options: [.displayInline], children: [
            UIAction(title: "Whole", image: UIImage(systemName: "rectangle.grid.1x2.fill"), handler: { (_) in
                self.gridItemSize = .whole
            }),
            UIAction(title: "Half", image: UIImage(systemName: "square.grid.2x2.fill"), handler: { (_) in
                self.gridItemSize = .half
            }),
            UIAction(title: "Third", image: UIImage(systemName: "square.grid.3x2.fill"), handler: { (_) in
                self.gridItemSize = .third
            }),
            UIAction(title: "Quarter", image: UIImage(systemName: "square.grid.4x3.fill"), handler: { (_) in
                self.gridItemSize = .quarter
            }),
        ])
    }()

    private lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0,
                                                                       y: 0,
                                                                       width: searchbarWidth,
                                                                       height: searchbarHeight))
    
    // MARK: - Init
    
    init(viewModel: CollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchbar()
        setupActivityIndicator()
        setupCollectionView()
        setupNavbar()
        setUpSubscriptions()
    }
    
    // MARK: - Helper
    
    private func setupCollectionView() {
        collectionView
            .register(ImageCollectionViewCell.self,
                      forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        datasource = FlickrDiffableDataSource(collectionView: collectionView)
        collectionView.delegate = self
        collectionView.contentInset.bottom = collectionViewBottomContentInset
    }
    
    private func setupSearchbar() {
        searchBar.placeholder = "Search something..."
        searchBar.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    private func setupActivityIndicator() {
        view.addSubview(loadingIndicator)
        let layoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            layoutGuide.centerXAnchor.constraint(equalTo: loadingIndicator.centerXAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: loadingIndicator.bottomAnchor,
                                                constant: loadingIndicatorBottomAnchor)
        ])
    }
    
    private func setupNavbar() {
        title = ""
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(systemItem: .edit,
                                primaryAction: nil,
                                menu: sizeMenu),
                UIBarButtonItem(title: "Login",
                                style: .plain,
                                target: self,
                                action: #selector(login))
            ]
        } else {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Edit",
                                style: .plain,
                                target: self,
                                action: #selector(showSizeSelection)),
                UIBarButtonItem(title: "Login",
                                style: .plain,
                                target: self,
                                action: #selector(login))
            ]
        }
    }
    
    private func showErrorAlert() {
        guard let message = viewModel.errorMessage else {return}
        showAlert(title: "Oops...", message: message)
    }
    
// MARK: - Subscriptions
    
    private func setUpSubscriptions() {
        subscribeForFetchingState()
        subscribeForData()
        subscribeForError()
    }
    private func subscribeForFetchingState() {
        viewModel.$isFetching.sink { [weak self] flag in
            if flag {
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
            }
        }.store(in: &subscriptions)
    }
    private func subscribeForData() {
        viewModel.$cellViewModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewModels in
                self?.populate(with: viewModels)
        }.store(in: &subscriptions)
    }
    private func subscribeForError() {
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.showErrorAlert()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Login
    
    @objc func login() {
       
    }
    // MARK: - Collection Helper
    
    @objc func showSizeSelection() {
        let ac = UIAlertController(title: "Select size", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Whole", style: .default, handler: { (_) in
            self.gridItemSize = .whole
        }))
        
        ac.addAction(UIAlertAction(title: "Half", style: .default, handler: { (_) in
            self.gridItemSize = .half
        }))
        
        ac.addAction(UIAlertAction(title: "Third", style: .default, handler: { (_) in
            self.gridItemSize = .third
        }))
        
        ac.addAction(UIAlertAction(title: "Quarter", style: .default, handler: { (_) in
            self.gridItemSize = .quarter
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    override func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(gridItemSize.rawValue),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        var contentInsetSize: CGFloat = 16
        switch gridItemSize {
        case .whole:
            contentInsetSize = 16
        case .half:
            contentInsetSize = 10
        case .third:
            contentInsetSize = 8
        case .quarter:
            contentInsetSize = 4
        }
        item.contentInsets = .uniform(size: contentInsetSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(gridItemSize.rawValue))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func populate(with viewModels: [CellViewModel]) {
        var snapshot = PhotosSnaphot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModels)
        datasource.apply(snapshot, animatingDifferences: true)
    }
}

extension GridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        // displaying last item
        if indexPath.row == viewModel.cellViewModels.count-1 {
            viewModel.fetchPhotos(pagination: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else { return }
        cell.flip()
    }
}

extension GridViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            viewModel.fetchPhotos(query: text)
        }
    }
}
