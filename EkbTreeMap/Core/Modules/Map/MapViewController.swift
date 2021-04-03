//
//  MapViewController.swift
//  EkbTreeMap
//
//  Created by s.petrov on 25.03.2021.
//

import UIKit
import SnapKit
import GoogleMaps
import YandexMapsMobile


final class MapViewController: UIViewController, YMKMapObjectTapListener, YMKMapInputListener {
    
    let repo = TreePointsRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "yandex"
        let mapView = YMKMapView()
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: 56.82, longitude: 60.62), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil)
        let objects = mapView.mapWindow.map.mapObjects
        mapView.mapWindow.map.addInputListener(with: self)
        objects.addTapListener(with: self)
        
        repo.points.forEach { point in
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
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        print(mapObject.userData)
        return true
    }
    
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        let circle = YMKCircle(center: point, radius: 2.5)
        map.mapObjects.addCircle(with: circle, stroke: .clear, strokeWidth: 0, fill: UIColor.systemTeal.withAlphaComponent(0.5))
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
        let circle = YMKCircle(center: point, radius: 5)
        map.mapObjects.addCircle(with: circle, stroke: .clear, strokeWidth: 0, fill: UIColor.systemTeal.withAlphaComponent(0.5))
    }
}
