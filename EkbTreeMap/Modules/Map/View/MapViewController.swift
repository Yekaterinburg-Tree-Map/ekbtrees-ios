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


final class MapViewController: UIViewController {
    
    // MARK: Private
    
    private var interactor: MapViewConfigurable!
    private var mapView: YMKMapView!
    
    private let didLoadSubject = PublishSubject<Void>()
    private let didTapPointSubject = PublishSubject<String>()
    private let didTapOnMapSubject = PublishSubject<TreePosition>()
    private let didChangeVisibleRegionSubject = PublishSubject<MapViewVisibleRegionPoints>()
    private let bag = DisposeBag()
    
    
    // MARK: Lifecycle
    
    class func instantiate(interactor: MapViewConfigurable) -> MapViewController {
        let vc = MapViewController()
        vc.interactor = interactor
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupConstraints()
        setupIO()
        
        didLoadSubject.onNext(())
    }
    
    
    // MARK: Private
    
    private func setupMap() {
        mapView = YMKMapView()
        setupListeners(for: mapView)
    }
    
    private func setupConstraints() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupListeners(for mapView: YMKMapView) {
        let objects = mapView.mapWindow.map.mapObjects
        objects.addTapListener(with: self)
        mapView.mapWindow.map.addInputListener(with: self)
        mapView.mapWindow.map.addCameraListener(with: self)
    }
    
    private func moveToPoint(_ point: TreePosition) {
        let target = YMKPoint(latitude: point.latitude, longitude: point.longitude)
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: target, zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5),
            cameraCallback: nil)
    }
    
    private func showPoints(_ points: [TreePointRepresentable]) {
        let objects = mapView.mapWindow.map.mapObjects
        objects.clear()
        points.forEach { point in
            let circle = YMKCircle(center: .init(latitude: point.position.latitude, longitude: point.position.longitude),
                                   radius: Float(point.radius))
            let stroke = UIColor.clear
            let obj = objects.addCircle(with: circle,
                                        stroke: stroke,
                                        strokeWidth: 0,
                                        fill: point.circleColor.withAlphaComponent(0.5))
            obj.userData = point.id
        }
    }
    
    private func handleCameraPositionChanged(map: YMKMap) {
        let visibleRegion = map.visibleRegion
        let cameraPosition = map.cameraPosition
        let zoom = Int(cameraPosition.zoom)
        let topLeftPoint = TreePosition(latitude: visibleRegion.topLeft.latitude,
                                        longitude: visibleRegion.topLeft.longitude)
        let topRightPoint = TreePosition(latitude: visibleRegion.topRight.latitude,
                                         longitude: visibleRegion.topRight.longitude)
        let bottomLeftPoint = TreePosition(latitude: visibleRegion.bottomLeft.latitude,
                                           longitude: visibleRegion.bottomLeft.longitude)
        let bottomRightPoint = TreePosition(latitude: visibleRegion.bottomRight.latitude,
                                            longitude: visibleRegion.bottomRight.longitude)
        let centerPoint = TreePosition(latitude: cameraPosition.target.latitude,
                                       longitude: cameraPosition.target.longitude)
        let region = MapViewVisibleRegionPoints(topLeft: topLeftPoint,
                                                topRight: topRightPoint,
                                                center: centerPoint,
                                                bottomLeft: bottomLeftPoint,
                                                bottomRight: bottomRightPoint,
                                                zoom: zoom)
        
        didChangeVisibleRegionSubject.onNext(region)
    }
    
    private func setupIO() {
        let input = interactor.configure(with: .init(didLoad: didLoadSubject,
                                                     didTapPoint: didTapPointSubject,
                                                     didTapOnMap: didTapOnMapSubject,
                                                     didChangeVisibleRegion: didChangeVisibleRegionSubject))
        
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
}


// MARK: - YMKMapObjectTapListener

extension MapViewController: YMKMapObjectTapListener {
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let pointData = mapObject.userData as? String else {
            return false
        }
        
        didTapPointSubject.onNext(pointData)
        return true
    }
}


// MARK: - YMKMapInputListener

extension MapViewController: YMKMapInputListener {
    
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        didTapOnMapSubject.onNext(.init(latitude: point.latitude, longitude: point.longitude))
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
        // unused
    }
}


// MARK: - YMKMapCameraListener

extension MapViewController: YMKMapCameraListener {
    
    func onCameraPositionChanged(with map: YMKMap,
                                 cameraPosition: YMKCameraPosition,
                                 cameraUpdateReason: YMKCameraUpdateReason,
                                 finished: Bool) {
        guard finished else {
            return
        }
        
        handleCameraPositionChanged(map: map)
    }
}
