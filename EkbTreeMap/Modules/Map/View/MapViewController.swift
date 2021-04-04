//
//  MapViewController.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.03.2021.
//

import UIKit
import SnapKit
import YandexMapsMobile
import RxSwift
import RxCocoa
import CoreLocation


final class MapViewController: UIViewController {
    
    // MARK: Private
    
    private var interactor: MapViewInteractorConfigurable!
    private var mapView: YMKMapView!
    
    private let didLoadSubject = PublishSubject<Void>()
    private let bag = DisposeBag()
    
    
    // MARK: Lifecycle
    
    class func instantiate(interactor: MapViewInteractorConfigurable) -> MapViewController {
        let vc = MapViewController()
        vc.interactor = interactor
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "yandex"
        setupMap()
        setupIO()
        
        didLoadSubject.onNext(())
    }
    
    
    // MARK: Private
    
    private func setupMap() {
        mapView = YMKMapView()
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        mapView.mapWindow.map.addInputListener(with: self)
        let objects = mapView.mapWindow.map.mapObjects
        objects.addTapListener(with: self)
    }
    
    private func setupIO() {
        let input = interactor.configureIO(with: .init(didLoad: didLoadSubject))
        
        input.moveToPoint
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { $0.moveToPoint($1) })
            .disposed(by: bag)
        
        input.visiblePoints
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { $0.showPoints($1) })
            .disposed(by: bag)
    }
    
    private func moveToPoint(_ point: CLLocationCoordinate2D) {
        let target = YMKPoint(latitude: point.latitude, longitude: point.longitude)
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: target, zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5),
            cameraCallback: nil)
    }
    
    private func showPoints(_ points: [TreePoint]) {
        let objects = mapView.mapWindow.map.mapObjects
        points.forEach { point in
            let circle = YMKCircle(center: .init(latitude: point.position.latitude, longitude: point.position.longitude),
                                   radius: Float(point.diameter ?? 1) / 2)
            let stroke = UIColor.clear
            let obj = objects.addCircle(with: circle,
                              stroke: stroke,
                              strokeWidth: 0,
                              fill: [UIColor.red, UIColor.blue].randomElement()!.withAlphaComponent(0.5))
            obj.userData = point.diameter
        }
    }
}


// MARK: - YMKMapObjectTapListener

extension MapViewController: YMKMapObjectTapListener {
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        print(mapObject.userData)
        return true
    }
}


// MARK: - YMKMapInputListener

extension MapViewController: YMKMapInputListener {
    
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        let circle = YMKCircle(center: point, radius: 2.5)
        map.mapObjects.addCircle(with: circle, stroke: .clear,
                                 strokeWidth: 0,
                                 fill: UIColor.systemTeal.withAlphaComponent(0.5))
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
        let circle = YMKCircle(center: point, radius: 5)
        map.mapObjects.addCircle(with: circle,
                                 stroke: .clear,
                                 strokeWidth: 0,
                                 fill: UIColor.systemTeal.withAlphaComponent(0.5))
    }
}
