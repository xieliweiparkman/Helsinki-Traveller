//
//  MapViewController.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RxCocoa
import RxSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: MapViewModelProtocol!
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        bindViewModel()
        setupCollectionView()
    }
    
    func setupMapView() {
        let coordinate = CLLocationCoordinate2DMake(60.25050735473633, 25.014970779418945)
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateRegion, animated: true)
        
        //New map type
        mapView.mapType = .mutedStandard
        mapView.delegate = self
        mapView.register(EventAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(EventClusterView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func bindViewModel() {
        viewModel.annotations.subscribe(onNext: { [weak self] annotations in
            guard let strongSelf = self else { return }
            strongSelf.mapView.removeAnnotations(strongSelf.mapView.annotations)
            if annotations.count != 0 {
                strongSelf.mapView.addAnnotations(annotations)
            }
        }).disposed(by: bag)
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let region = MKCoordinateRegion(center: view.annotation!.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
    }
}


extension MapViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.annotations.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCardCollectionViewCell", for: indexPath) as! MapCardCollectionViewCell
        if viewModel.isEvent {
            let event = viewModel.mainViewModel.cleanEvents.value[indexPath.item]
            cell.configure(event: event)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MapCardCollectionViewCell else { return }
        let imageView = cell.eventImageView

        if viewModel.isEvent {
            let event = viewModel.mainViewModel.cleanEvents.value[indexPath.row]
            if event.description.images?.count != 0 {
                imageView?.setImage(urlString: event.description.images![0].url?.cleanUrl() ?? "")
            }
        } else {
            let place = viewModel.mainViewModel.places.value[indexPath.row]
            if place.description.images?.count != 0 {
                imageView?.setImage(urlString: place.description.images![0].url?.cleanUrl() ?? "")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: appWidth-36, height: (appWidth-36) * 6 / 11)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }

}
