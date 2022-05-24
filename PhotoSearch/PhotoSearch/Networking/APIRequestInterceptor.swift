//
//  RequestInterceptor.swift
//  PhotoSearch
//
//  Created by bnulo on 5/20/22.
//

import Foundation
import Alamofire

class APIRequestInterceptor: RequestInterceptor {
  let retryLimit = 5
  let retryDelay: TimeInterval = 10

  func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    let response = request.task?.response as? HTTPURLResponse
    //Retry for 5xx status codes
    if
      let statusCode = response?.statusCode,
      (500...599).contains(statusCode),
      request.retryCount < retryLimit {
        completion(.retryWithDelay(retryDelay))
    } else {
      return completion(.doNotRetry)
    }
  }
}

