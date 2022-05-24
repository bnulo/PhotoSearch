//
//  OAuthHelper.swift
//  PhotoSearch
//
//  Created by bnulo on 5/24/22.
//

import Foundation
import CryptoKit

struct OAuthHelper {
    
    let headers: [String: String]
    let autorizationValue: String
    
    init() {
        let headers = OAuthHelper.getHeaders()
        self.headers = headers
        self.autorizationValue = OAuthHelper.getAuthorizationValue(for: headers)
    }
    
    static func getHeaders() -> [String: String] {
        
        let oauthVersion = "1.0"
        let httpMethod = "GET"
        let callback = APIConstants.oauthCallback
        let consumerKey = APIConstants.consumerKey
        let signatureMethod = APIConstants.oauthSignatureMethod
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        let nonce = UUID().uuidString
        //        let nonce = timeStamp
            let requestTokenURL = APIConstants.requestTokenUrl
            
            let oauthParameters = [
                "oauth_callback": callback,
                "oauth_consumer_key": consumerKey,
                "oauth_nonce": nonce,
                "oauth_signature_method": signatureMethod,
                "oauth_timestamp": timeStamp,
                "oauth_version": oauthVersion
            ]
            
            let parameterString = OAuthHelper.getParameterString(parameters: oauthParameters)

            let parameters = [
              httpMethod,
              requestTokenURL,
              parameterString
            ]

            let baseString = OAuthHelper.getBaseString(parameters: parameters)
            let key = APIConstants.getRequestTokenSignatureKey
            let signature = OAuthHelper.getSignature(key: key, message: baseString)
            print(signature)
            
            let headers = [
                "oauth_callback": callback,
              "oauth_consumer_key": consumerKey,
              "oauth_nonce": nonce,
              "oauth_signature": signature,
              "oauth_signature_method": signatureMethod,
              "oauth_timestamp": timeStamp,
              "oauth_version": oauthVersion
            ]
//                let sortedHeaders = headers
//                    .sorted { (first, second) -> Bool in
//                        return first.key < second.key
//                    }
        return headers
    }
    
    static func getAuthorizationValue(for headers: [String: String]) -> String {
        let oauth_values = headers
            .map{"\($0.encodeURL()!)=\"\($1.encodeURL()!)\""}

        let authorization = "OAuth \(oauth_values.joined(separator: ","))"
        
        return authorization
    }
    
    static func getSignature(key:String, message:String) -> String {
        
        let key = SymmetricKey(data: key.data(using: .utf8)!)
        let signature = HMAC<Insecure.SHA1>.authenticationCode(for: message.data(using: .utf8)!, using: key)
        let signatureString = Data(signature).base64EncodedString(options: .lineLength64Characters)
        return signatureString
      }

    static func getBaseString(parameters: [String]) -> String {
        
      let encodedValues = parameters.map{ $0.encodeURL()!}
      let joinedValue = encodedValues.joined(separator: "&")
      return joinedValue
    }

    static func getParameterString(parameters:[String: String]) -> String {
        
        let sorted = parameters.sorted { (first, second) -> Bool in
            first.key < second.key
        }
      let encodedValues = sorted.map {($0.encodeURL()!, $1.encodeURL()!)}
      let dictionary = encodedValues.reduce(into: [String: String]()) { $0[$1.0] = $1.1 }
      let sortedValues = dictionary.sorted { $0.0 < $1.0 } .map { $0 }
      let eachJoinedValues = sortedValues.map { "\($0)=\($1)" }
      let joinedValue = eachJoinedValues.joined(separator: "&")
      return joinedValue
    }
    
    static func getAuthenticateURL(_ oauthToken: String) -> URL{
        
        let authenticateURL = APIConstants.authenticationUrl
        var urlComponents = URLComponents(string: authenticateURL)!
        urlComponents.queryItems = [.init(name: "oauth_token", value: oauthToken)]
        return urlComponents.url!
      }
}
