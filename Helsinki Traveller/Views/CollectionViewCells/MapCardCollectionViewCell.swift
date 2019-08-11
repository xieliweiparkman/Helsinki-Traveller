//
//  MapCardCollectionViewCell.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 09/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MapCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var viewModel: MainViewModelProtocol!
    fileprivate var onReuseBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuseBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 5
    }
    
    func configure(event: Event) {
        nameLabel.text = event.name.fi ?? ""
        addressLabel.text = event.location.address.streetAddress ?? ""
        tagLabel.text = event.tagsString()
        bodyLabel.text = event.description.body?.convertHtml().string ?? ""
    }
}
