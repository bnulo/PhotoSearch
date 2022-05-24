//
//  FlickrDiffableDataSource.swift
//  PhotoSearch
//
//  Created by bnulo on 5/21/22.
//

import UIKit

class FlickrDiffableDataSource: UICollectionViewDiffableDataSource<Int, CellViewModel> {
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { (collectionView, indexPath, viewModel) -> UICollectionViewCell? in
            guard let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier,
                                         for: indexPath) as? ImageCollectionViewCell
            else {
                return UICollectionViewCell()
            }

            cell.viewModel = viewModel
            return cell

        }
    }
}

