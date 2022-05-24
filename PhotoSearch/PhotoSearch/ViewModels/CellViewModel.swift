//
//  CellViewModel.swift
//  PhotoSearch
//
//  Created by bnulo on 5/20/22.
//

import UIKit

final class CellViewModel: ObservableObject {

    // MARK: - Properties

    let photo: Photo

    @Published private(set) var title: String = ""
    @Published private(set) var imageUrl: URL?
    
    init(photo: Photo,
         size: ImageSizeModel = ImageSizeModel(imageSize: .px150CroppedSquare) ) {
        self.photo = photo
        self.title = photo.title ?? ""
        self.imageUrl = URL(photo: photo, size: size)
    }
}

extension CellViewModel: Hashable, Equatable {

    static func == (lhs: CellViewModel, rhs: CellViewModel) -> Bool {
        return lhs.photo.id == rhs.photo.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(photo.id)
    }
    
}
