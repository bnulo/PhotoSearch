//
//  APIConstants.swift
//  PhotoSearch
//
//  Created by bnulo on 5/20/22.
//

import Foundation

enum APIConstants {

    static let authenticationUrl = "https://www.flickr.com/services/oauth/authorize"
    static let requestTokenUrl = "https://www.flickr.com/services/oauth/request_token"
    static let photoBaseURL = "https://live.staticflickr.com"
    static let consumerKey = "CONSUMER_KEY"
    static let consumerSecret = "CONSUMER_SECRET"
    static let perPage = "24"
    static let oauthCallback = "http://photosearch.com"
    static let oauthSignatureMethod = "HMAC-SHA1"
    static let getRequestTokenSignatureKey = "\(consumerKey.encodeURL()!)&\("".encodeURL()!)"
}
