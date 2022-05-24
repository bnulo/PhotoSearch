//
//  APIManager.swift
//  PhotoSearch
//
//  Created by bnulo on 5/20/22.
//

import Foundation
import Alamofire

class APIManager: APIServiceProtocol {

  static let shared = APIManager()

  let sessionManager: Session = {
    let configuration = URLSessionConfiguration.af.default
//      configuration.timeoutIntervalForRequest = 30 // we do not use cause we  cach
//      configuration.waitsForConnectivity = true // we do not use cause we cach
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    let responseCacher = ResponseCacher(behavior: .modify { _, response in
      let userInfo = ["date": Date()]
      return CachedURLResponse(
        response: response.response,
        data: response.data,
        userInfo: userInfo,
        storagePolicy: .allowed)
    })

    let networkLogger = NetworkLogger()
    let interceptor = APIRequestInterceptor()

    return Session(
      configuration: configuration,
      interceptor: interceptor,
      cachedResponseHandler: responseCacher,
      eventMonitors: [networkLogger])
  }()
    
    func searchPhotos(query: String, page: Int, completion: @escaping (Result<SearchPhotosResponse, AFError>) -> Void) {
    sessionManager.request(Router.searchPhotos(query, page))
      .responseDecodable(of: SearchPhotosResponse.self) { response in
          
          switch response.result {
          case .failure(let error):
              completion(.failure(error))
          case .success(let responseResult):
              completion(.success(responseResult))
          }
      }
  }
    // MARK: - OAuth 1.0
    
    /// 1- Get Request Token
    ///  https://www.flickr.com/services/oauth/request_token
    ///  reponse:
    ///  oauth_callback_confirmed=true&oauth_token=xxxxxxxxxxxxxx&oauth_token_secret=xxxxxx
    ///
    ///  2- Getting the User Authorization
    ///  https://www.flickr.com/services/oauth/authorize?oauth_token=xxxxx
    ///  User will be redirected to a collback url and with deeplink we get the response in the app
    ///
    ///  3- Exchanging the Request Token for an Access Token
    ///  https://www.flickr.com/services/oauth/access_token
    ///  response:
    ///  fullname=xxx&oauth_token=xxxx&oauth_token_secret=xxxx&user_nsid=xxxx&username=xxxxxxxxxx
    ///  We add the token and token_secret to the headers of private requests
    ///
    ///  4- Calling the Flickr API with OAuth
    ///  https://www.flickr.com/services/rest?nojsoncallback=1&format=json&method=flickr.test.login
    ///  response:
    ///  {
    ///   "user": {
    ///        "id": "xxxxxx",
    ///        "username": {
    ///            "_content": "xxxxxxx"
    ///        },
    ///        "path_alias": null
    ///    },
    ///    "stat": "ok"
    ///}
    func getRequestToken(completion: @escaping (URL?) -> Void) {
      sessionManager.request(Router.getRequestToken)
            .responseData { data in
                guard let unwrappedData = data.data else {
                    return completion(nil)
                }
                
                print(String(data: unwrappedData, encoding: .utf8)!)
                let values = String(data: unwrappedData,
                                    encoding: .utf8)!
                    .split(separator: "&")
                    .map{$0.split(separator: "=")}
                
                let oauthCallbackConfirmed = String(values[0][1])
                let oauthToken = String(values[1][1])
                let oauthTokenSecret = String(values[1][1])
                let authenticateURL = OAuthHelper.getAuthenticateURL(oauthToken)
                print(authenticateURL)
                
                if oauthCallbackConfirmed == "true" {
                    TokenManager.shared.save(oauthToken, for: .token)
                    TokenManager.shared.save(oauthTokenSecret, for: .tokenSecret)
                    completion(authenticateURL)
                } else {
                    completion(nil)
                }
                
            }
    }
}
