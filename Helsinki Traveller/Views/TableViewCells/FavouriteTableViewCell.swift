//
//  FavouriteTableViewCell.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FavouriteTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: MainViewModelProtocol!
    fileprivate var onReuseBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuseBag = DisposeBag()
    }
    
    func configure() {
        viewModel.favouriateEvents.subscribe(onNext: { [weak self] _ in
            if self?.collectionView.tag == 0 || self?.collectionView.tag == 1 {
                self?.collectionView.reloadData()
            }
        }).disposed(by: onReuseBag)
    }

}

extension FavouriteTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tag == 0 {
            //cell.imageViewRatio.constant = 2/3
            return UserDefaultsManager.shared.favouriteEvents.count
        } else if tag == 1 {
            return viewModel.cleanEvents.value.count
        } else {
            return viewModel.places.value.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as! FavouriteCollectionViewCell

        cell.layoutSubviews()
        cell.viewModel = viewModel
        if tag == 0 {
            cell.addToFavouriteButton.alpha = 1
            let event = viewModel.favouriateEvents.value[indexPath.row]
            cell.configureFavouriteCell(dict: event)
        } else if tag == 1 {
            cell.addToFavouriteButton.alpha = 1
            let event = viewModel.cleanEvents.value[indexPath.row]
            cell.configure(event: event)
        } else {
            cell.addToFavouriteButton.alpha = 0
            let place = viewModel.places.value[indexPath.row]
            cell.configure(place: place)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? FavouriteCollectionViewCell else { return }
        let imageView = cell.bgImageView
        
        if tag == 0 {
            let event = viewModel.favouriateEvents.value[indexPath.row]
            if let url = event["url"] as? String {
                imageView?.setImage(urlString: url.cleanUrl())
            } else {
                imageView?.image = UIImage(named: "MyHel")
            }

        } else if tag == 1 {
            let event = viewModel.cleanEvents.value[indexPath.row]
            if event.description.images?.count == 0 {
                imageView?.image = UIImage(named: "MyHel")
            } else {
                let url = event.description.images?[0].url ?? ""
                imageView?.setImage(urlString: url.cleanUrl())
            }
        } else {
            let place = viewModel.places.value[indexPath.row]
            if place.description.images?.count == 0 {
                imageView?.image = UIImage(named: "MyHel")
            } else {
                let url = place.description.images?[0].url ?? ""
                imageView?.setImage(urlString: url.cleanUrl())
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if tag == 0 {
            return CGSize(width: 225, height: 300)
        } else {
            return CGSize(width: 180, height: 180)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
