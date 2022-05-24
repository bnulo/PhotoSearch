//
//  APIMockService.swift
//  PhotoSearch
//
//  Created by bnulo on 5/21/22.
//

import Foundation
import Alamofire

struct APIMockService: APIServiceProtocol {
    // For testing
    var result: Result<SearchPhotosResponse, AFError>
    
    func searchPhotos(query: String, page: Int, completion: @escaping (Result<SearchPhotosResponse, AFError>) -> Void) {
        completion(result)
    }
}
