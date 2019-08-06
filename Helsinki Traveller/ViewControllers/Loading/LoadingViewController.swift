//
//  LoadingViewController.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingImageView: UIImageView!
    
    var loadingViewModel: LoadingViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        animateImageView()
        loadingViewModel.setup()
    }
    
    func animateImageView() {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.5, animations: {
                self.loadingImageView.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.5, animations: {
                self.loadingImageView.alpha = 1
            })
        }, completion: nil)
    }

}
