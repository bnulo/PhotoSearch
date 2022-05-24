//
//  CollectionViewModel.swift
//  PhotoSearch
//
//  Created by bnulo on 5/20/22.
//

import Foundation
import Combine

class CollectionViewModel: ObservableObject {

    @Published private(set) var cellViewModels: [CellViewModel] = []
    @Published private(set) var isFetching = false
    @Published private(set) var page = 0
    @Published private(set) var pages = 1
    @Published private(set) var query = ""
    @Published private(set) var errorMessage: String? = nil
    
    private var isPaginating = false
    let service: APIServiceProtocol
    
    init(service: APIServiceProtocol = APIManager.shared) {
        self.service = service
    }

    // MARK: -

    func fetchPhotos(pagination:Bool=false, query: String="") {

        guard isPaginating == false else { return }
        if pagination {
            guard page < pages else {return}
            isPaginating = true
        } else {
            self.query = query
            self.cellViewModels = []
            page = 0
        }

        onServiceWillRequest()
        service.searchPhotos(query: self.query, page: page+1) { [self] result in
            switch result {
            case .failure(let error):
                errorMessage = error.localizedDescription
            case .success(let searchPhotosResponse):
                let items = searchPhotosResponse.photos.items ?? []
                let viewModels = items
                    .compactMap { CellViewModel(photo: $0) }
                DispatchQueue.main.async {
                    cellViewModels.append(contentsOf: viewModels)
                    if let unWrappedPages = searchPhotosResponse.photos.pages {
                        pages = unWrappedPages
                    }
                    if let unWrappedPage = searchPhotosResponse.photos.page {
                        page = unWrappedPage
                    }
                }
            }
            onServiceDidRequest()
        }
    }

    // MARK: - Helper

    func onServiceWillRequest() {
        isFetching = true
        errorMessage = nil
    }

    func onServiceDidRequest() {
        isPaginating = false
        isFetching = false
    }
}
