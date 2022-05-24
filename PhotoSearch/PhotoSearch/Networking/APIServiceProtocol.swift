//
//  APIServiceProtocol.swift
//  PhotoSearch
//
//  Created by bnulo on 5/21/22.
//

import Foundation
import Alamofire

protocol APIServiceProtocol {
    
    func searchPhotos(query: String, page: Int, completion: @escaping (Result<SearchPhotosResponse, AFError>) -> Void)
}
