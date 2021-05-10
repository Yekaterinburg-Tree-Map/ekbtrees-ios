//
//  TreeDetailsMapView.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import YandexMapsMobile
import UIKit


final class TreeDetailsMapView: UIView, ViewRepresentable {
    
    // MARK: Public Structures
    
    struct DisplayData {
        
        let treePoint: TreePosition
    }
    
    
    // MARK: Private Properties
    
    private lazy var mapView: YMKMapView = {
        let mapView = YMKMapView()
        mapView.mapWindow.map.isZoomGesturesEnabled = false
        mapView.mapWindow.map.isTiltGesturesEnabled = false
        mapView.mapWindow.map.isScrollGesturesEnabled = false
        mapView.mapWindow.map.isRotateGesturesEnabled = false
        return mapView
    }()
    
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public
    
    func configure(with data: DisplayData) {
        let point = YMKPoint(latitude: data.treePoint.latitude, longitude: data.treePoint.longitude)
        let cameraPosition = YMKCameraPosition(target: point, zoom: 17, azimuth: 0, tilt: 0)
        mapView.mapWindow.map.move(with: cameraPosition)
        
        mapView.mapWindow.map.mapObjects.addPlacemark(with: point)
    }
    
    
    // MARK: Private
    
    private func setupConstraints() {
        addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.height.equalTo(snp.width)
        }
    }
}
