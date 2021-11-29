//
//  UserCellView.swift
//  GeoTestTask
//
//  Created by Mayorov Genrikh on 26.10.2021.
//

import Foundation
import UIKit
import Kingfisher
import RxSwift

final class UserCellView: UITableViewCell {
    public static let cellIdentidier = "UserCellId"
    public static let cellHeight = CGFloat(70)
    
    private let userImage = UIImageView()
    private let userNameLabel = UILabel()

    private var disposeBag = DisposeBag()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setData(viewModel: UserCellViewModel) {
        disposeBag = DisposeBag()
        viewModel.userName.bind(to: userNameLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.userAvatar.subscribe(onNext: { newURL in
            if let urlString = newURL, let url = URL(string: urlString) {
                self.userImage.kf.setImage(with: url, placeholder: UIImage.placeholder)
            }
        })
        .disposed(by: disposeBag)
    }

    func setup() {
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userImage)

        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16).isActive = true
        userNameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8).isActive = true

        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        userImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor).isActive = true
        userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true

        userImage.image = UIImage.placeholder
        userImage.layer.cornerRadius = 8
        userImage.clipsToBounds = true

        contentView.addSubview(userImage)
        contentView.addSubview(userNameLabel)
    }
}
