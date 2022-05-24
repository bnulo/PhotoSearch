//
//  PhotoSearchTests.swift
//  PhotoSearchTests
//
//  Created by bnulo on 5/21/22.
//

import XCTest
import Combine
import Alamofire
@testable import PhotoSearch

class PhotoSearchTests: XCTestCase {
    var subscriptions = Set<AnyCancellable>()

    override func tearDown() {
        subscriptions = []
    }

    func test_getting_searchPhotosResponse_success() {
        let result = Result<SearchPhotosResponse, AFError>
            .success(SearchPhotosResponse.example())
        let viewModel = CollectionViewModel(service: APIMockService(result: result))
        viewModel.fetchPhotos()
        let promise = expectation(description: "getting photos")
        viewModel.$cellViewModels.sink { viewModels in
            if viewModels.count > 0 {
                promise.fulfill()
            }
        }.store(in: &subscriptions)

        wait(for: [promise], timeout: 2)
    }
    
    func test_getting_searchPhotosResponse_error() {
       
        let result = Result<SearchPhotosResponse, AFError>.failure(AFError.urlRequestValidationFailed(reason: AFError.URLRequestValidationFailureReason.bodyDataInGETRequest(Data())))
         let viewModel = CollectionViewModel(service: APIMockService(result: result))
        viewModel.fetchPhotos()
        let promise = expectation(description: "show error message")
        viewModel.$cellViewModels.sink { viewModels in
            if !viewModels.isEmpty {
                XCTFail()
            }
        }.store(in: &subscriptions)
        
        
        viewModel.$errorMessage.sink { message in
            if message != nil {
                promise.fulfill()
            }
        }.store(in: &subscriptions)
        
        wait(for: [promise], timeout: 2)
    }

}
