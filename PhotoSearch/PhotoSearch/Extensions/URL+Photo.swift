//
//  URL+Photo.swift
//  PhotoSearch
//
//  Created by bnulo on 5/22/22.
//

import Foundation

extension URL {
    
    init?(photo: Photo, size: ImageSizeModel) {
        let base = "\(APIConstants.photoBaseURL)/"
        guard let server = photo.server,
              let id = photo.id,
              let secret = photo.secret
        else { return nil }
        let path = "\(server)/\(id)_\(secret)_\(size.suffix).jpg"
        let urlString = base + path
        self.init(string: urlString)
    }
}
