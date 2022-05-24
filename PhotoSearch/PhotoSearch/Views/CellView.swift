//
//  CellView.swift
//  PhotoSearch
//
//  Created by bnulo on 5/20/22.
//

import UIKit
import Combine
import Kingfisher
import SwiftUI

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "imageCollectionViewCell"
    var viewModel: CellViewModel?
    var subscriptions = Set<AnyCancellable>()
    let labelPadding: CGFloat = 12
    let cornerRadius:CGFloat = 12
    private var isImageViewHidden = false
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.systemFont(ofSize: 48, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.clipsToBounds = true
       return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4
        return imageView
    }()

    // MARK: -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setupViews()
        setUpSubscriptions()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    
        isImageViewHidden = false
        imageView.kf.cancelDownloadTask()
    }

    // MARK: - Helper
    
    private func setupViews() {
        containerView.frame = contentView.bounds
        imageView.frame = containerView.bounds
        label.frame = containerView.frame.inset(by: UIEdgeInsets(top: labelPadding,
                                                                 left: labelPadding,
                                                                 bottom: labelPadding,
                                                                 right: labelPadding))
        containerView.layer.cornerRadius = cornerRadius
        containerView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        imageView.isHidden = isImageViewHidden
        label.isHidden = !isImageViewHidden
    }
    private func setUpSubscriptions() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.$imageUrl.sink(receiveValue: { [weak self] url in
            self?.imageView.kf.setImage(with: url)
        }).store(in: &subscriptions)
        viewModel.$title.sink { [weak self] title in
            self?.label.text = title
        }.store(in: &subscriptions)
    }

    func flip() {
        isImageViewHidden.toggle()
        imageView.isHidden = isImageViewHidden
        label.isHidden = !isImageViewHidden
        UIView.transition(with: containerView, duration: 0.5,
                          options: .transitionFlipFromTop,
                          animations: nil, completion: nil)
    }
}
