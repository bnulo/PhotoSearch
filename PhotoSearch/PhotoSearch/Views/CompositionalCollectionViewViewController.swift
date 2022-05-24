//
//  CompositionalCollectionViewViewController.swift
//  PhotoSearch
//
//  Created by bnulo on 5/21/22.
//

import UIKit

class CompositionalCollectionViewViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func createLayout() -> UICollectionViewLayout {
        preconditionFailure("Override createLayout() to provide compositional layout for the collection view")
    }
}

