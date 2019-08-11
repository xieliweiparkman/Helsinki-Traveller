//
//  DetailsViewController.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 08/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hasTagLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var viewModel: DetailsViewModelProtocol!
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
    }
    
    func bindViewModel() {
        switch viewModel.detailsType {
        case .Event:
            viewModel.event.subscribe(onNext: { [weak self] event in
                guard let strongSelf = self,
                    let event = event else { return }
                strongSelf.setupUIForEvent(event: event)
                strongSelf.setImages(images: event.description.images)
            }).disposed(by: bag)
        default:
            print("")
        }

        viewModel.images.subscribe(onNext: { [weak self] _ in
            self?.imageCollectionView.reloadData()
        }).disposed(by: bag)
    }
    
    func setupUIForEvent(event: Event) {
        nameLabel.text = event.name.fi ?? ""
        addressLabel.text = event.location.address.streetAddress ?? ""
        hasTagLabel.text = event.tagsString()
        eventTimeLabel.text = event.startTimeString()
        introLabel.text = event.description.intro ?? nameLabel.text
        desLabel.attributedText = (event.description.body ?? "").convertHtml()
        
        guard let lat = event.location.lat,
            let lon = event.location.lon else { return }
        let coordinate = CLLocationCoordinate2DMake(lat, lon)
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(coordinateRegion, animated: true)        
        mapView.mapType = .mutedStandard
        mapView.register(EventAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let annotaion = EventAnnotation(color: .purple,
                                        type: .event,
                                        coordinate: coordinate,
                                        id: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.addAnnotation(annotaion)
    }
    
    func setImages(images: [Image]?) {
        viewModel.images.accept(images)
    }
}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImagesCollectionViewCell,
            let images = viewModel.images.value else { return }
        let imageView = cell.bgImageView
        imageView?.setImage(urlString: images[indexPath.item].url?.cleanUrl() ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: appWidth, height: appWidth * 9 / 16)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
