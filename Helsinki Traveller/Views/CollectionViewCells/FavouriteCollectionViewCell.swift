//
//  FavouriteCollectionViewCell.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var addToFavouriteButton: UIButton!
    
    var viewModel: MainViewModelProtocol!
    fileprivate var onReuseBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuseBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addToFavouriteButton.layer.cornerRadius = 22
    }
    
    func configureFavouriteCell(dict: [String: Any]) {
        addToFavouriteButton.setImage(UIImage(named: "Like"), for: .normal)
        guard let title = dict["title"] as? String,
            let des = dict["des"] as? String,
            let id = dict["id"] as? String else { return }
        titleLabel.text = title
        desLabel.text = des
        addToFavouriteButton.rx.tap.map { id }.bind(to: viewModel.didTapOnRemoveFavouriteButton).disposed(by: onReuseBag)
        
    }
    
    func configure(event: Event) {
        if event.isFavouriteEvent() {
            addToFavouriteButton.setImage(UIImage(named: "Like"), for: .normal)
        } else {
            addToFavouriteButton.setImage(UIImage(named: "Unlike"), for: .normal)
        }
        
        addToFavouriteButton.rx.tap.map { event }.bind(to: viewModel.didTapFavouriteButton).disposed(by: onReuseBag)
        
        addShadow(roundView: false)
        titleLabel.text = event.name.en ?? event.name.fi ?? ""
        desLabel.text = (event.description.body ?? "").convertHtml().string
    }
    
    func configure(place: Place) {
        addShadow(roundView: false)
        titleLabel.text = place.name.en ?? place.name.fi ?? ""
        desLabel.text = place.description.body ?? ""
    }
    
    
}
