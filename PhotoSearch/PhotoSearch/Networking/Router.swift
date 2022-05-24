//
//  Router.swift
//  PhotoSearch
//
//  Created by bnulo on 5/20/22.
//

import Foundation
import Alamofire


enum Router {

    var oauthHelper: OAuthHelper {
        OAuthHelper()
    }

    case getRequestToken
    case searchPhotos(String, Int)

  var baseURL: String {
      
      switch self {
      case .getRequestToken:
          return APIConstants.requestTokenUrl
      case .searchPhotos:
          return "https://www.flickr.com"
      }
  }
  var path: String {
      
      switch self {
      case .searchPhotos:
          return "/services/rest"
      case .getRequestToken:
          return ""
      }
  }

  var method: HTTPMethod {
      
      switch self {
      case .searchPhotos, .getRequestToken:
          return .get
      }
  }
    
    var headers: HTTPHeaders {
    
        switch self {
        case .getRequestToken:
            return ["Authorization": oauthHelper.autorizationValue]
        case .searchPhotos:
            return [:]
        }
    }
    
  var parameters: [String: String]? {
    switch self {

    case .getRequestToken:
        return oauthHelper.headers
        
    case .searchPhotos(let query, let page):
        return ["method": "flickr.photos.search",
                "api_key": APIConstants.consumerKey,
                "text": query,
                "per_page": APIConstants.perPage,
                "page": "\(page)",
                "format": "json",
                "nojsoncallback":"1"        
                 ]
    }
  }
}

// MARK: - URLRequestConvertible
extension Router: URLRequestConvertible {
    
  func asURLRequest() throws -> URLRequest {
      
    let url = try baseURL.asURL().appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.method = method
      request.headers = headers
    if method == .get {
      request = try URLEncodedFormParameterEncoder()
        .encode(parameters, into: request)
    } else if method == .post {
      request = try JSONParameterEncoder().encode(parameters, into: request)
      request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    return request
  }
    
}
