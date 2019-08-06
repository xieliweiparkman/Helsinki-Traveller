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

    var viewModel: MapViewModelProtocol!
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        bindViewModel()
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
