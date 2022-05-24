//
//  Model.swift
//  PhotoSearch
//
//  Created by bnulo on 5/20/22.
//

import Foundation


struct SearchPhotosResponse: Decodable {
    let photos: Photos
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case photos
        case status = "stat"
    }
    
    static func example() -> SearchPhotosResponse {
        return SearchPhotosResponse(photos: Photos.example(), status: "ok")
    }
}

struct Photos: Decodable {
    let page, pages, perpage, total: Int?
    let items: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case page, pages, perpage, total
        case items = "photo"
    }
    static func example() -> Photos {
        Photos(page: 4, pages: 2923, perpage: 24, total: 70134,
               items: [Photo.example1(), Photo.example2(), Photo.example3()])
    }
}

struct Photo: Decodable {
    let id, owner, secret, server, title: String?
    let farm, isPublic, isFriend, isFamily: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
    
    static func example1() -> Photo {
        Photo(id: "52062521072", owner: "127873079@N05", secret: "8df5d9e299",
              server: "65535", title: "20220507-IMG_9947",
              farm: 66, isPublic: 1, isFriend: 0, isFamily: 0)
    }
    static func example2() -> Photo {
        Photo(id: "52062518212", owner: "127873079@N05", secret: "5e258fd514",
              server: "65535", title: "20220507-IMG_9976",
              farm: 66, isPublic: 1, isFriend: 0, isFamily: 0)
    }
    static func example3() -> Photo {
        Photo(id: "52055602547", owner: "85618249@N00", secret: "5874722376",
              server: "65535", title: "Springhead Dynamites v Great Moor 7 May 22 -15",
              farm: 66, isPublic: 1, isFriend: 0, isFamily: 0)
    }
}
extension Photo: Hashable {}
