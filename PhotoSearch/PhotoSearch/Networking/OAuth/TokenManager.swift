//
//  TokenManager.swift
//  PhotoSearch
//
//  Created by bnulo on 5/20/22.
//

import Foundation

class TokenManager {
    
    static let shared = TokenManager()


  let secureStore: SecureStore = {
    let accessTokenQueryable = GenericPasswordQueryable(service: "")
    return SecureStore(secureStoreQueryable: accessTokenQueryable)
  }()

    func save(_ token: String, for apiToken: APIToken) {
    do {
        try secureStore.setValue(token, for: apiToken.rawValue)
    } catch let exception {
        print("Error saving \(apiToken.rawValue): \(exception)")
    }
  }

    func fetch(_ apiToken: APIToken) -> String? {
    do {
        return try secureStore.getValue(for: apiToken.rawValue)
    } catch let exception {
        print("Error fetching \(apiToken.rawValue): \(exception)")
    }
    return nil
  }

    func clear(_ apiToken: APIToken) {
    do {
        return try secureStore.removeValue(for: apiToken.rawValue)
    } catch let exception {
        print("Error clearing \(apiToken.rawValue): \(exception)")
    }
  }

}
