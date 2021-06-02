//
//  MapObjectsVisitor.swift
//  EkbTreeMap
//
//  Created by s.petrov on 27.05.2021.
//

import YandexMapsMobile
import RxSwift


struct MapObjectsChanges<T> {
    
    var additions: [T] = []
    var clusterDeletions: [YMKPlacemarkMapObject] = []
    var pointDeletions: [YMKCircleMapObject] = []
}


protocol MapObjectsVisiting: YMKMapObjectVisitor {
    
    func filterTreePoints(_ trees: [TreePointRepresentable]) -> Observable<MapObjectsChanges<TreePointRepresentable>>
    func filterClusterPoints(_ clusters: [TreeClusterRepresentable]) -> Observable<MapObjectsChanges<TreeClusterRepresentable>>
}


final class MapObjectsVisitor: NSObject, MapObjectsVisiting {
    
    typealias TreePointsChanges = MapObjectsChanges<TreePointRepresentable>
    typealias ClusterPointsChanges = MapObjectsChanges<TreeClusterRepresentable>
    
    // MARK: Private Properties
    
    private let treeChangesSubject = PublishSubject<TreePointsChanges>()
    private let clusterChangesSubject = PublishSubject<ClusterPointsChanges>()
    
    private var treeChanges: TreePointsChanges = .init()
    private var clusterChanges: ClusterPointsChanges = .init()
    
    private var newTrees: [TreePointRepresentable] = []
    private var newClusters: [TreeClusterRepresentable] = []
    
    private var currentClusterObjects: [YMKPlacemarkMapObject] = []
    private var currentTreeObjects: [YMKCircleMapObject] = []
    
    private var isFilteringTrees = false
    
    
    // MARK: Public
    
    func filterTreePoints(_ trees: [TreePointRepresentable]) -> Observable<TreePointsChanges> {
        cleanCache()
        isFilteringTrees = true
        newTrees = trees
        return treeChangesSubject
    }
    
    func filterClusterPoints(_ clusters: [TreeClusterRepresentable]) -> Observable<ClusterPointsChanges> {
        cleanCache()
        isFilteringTrees = false
        newClusters = clusters
        return clusterChangesSubject
    }
    
    
    // MARK: Private
    
    private func cleanCache() {
        currentClusterObjects = []
        currentTreeObjects = []
        newTrees = []
        newClusters = []
    }
    
    private func countTreeChanges() {
        let objectIds = Set(currentTreeObjects.compactMap { $0.userData as? Int })
        let treeIds = Set(newTrees.map(\.id))
        var additions: [TreePointRepresentable] = []
        var deletions: [YMKCircleMapObject] = []
        for tree in newTrees {
            if !objectIds.contains(tree.id) {
                additions.append(tree)
            }
        }
        for object in currentTreeObjects {
            guard let id = object.userData as? Int else {
                continue
            }
            if !treeIds.contains(id) {
                deletions.append(object)
            }
        }
        treeChanges = .init(additions: additions, clusterDeletions: currentClusterObjects, pointDeletions: deletions)
        treeChangesSubject.onNext(treeChanges)
    }
    
    private func countClustersChanges() {
        let objectPositions = Set(
            currentClusterObjects.map { TreePosition(latitude: $0.geometry.latitude, longitude: $0.geometry.longitude) }
        )
        let clusterPositions = Set(newClusters.map(\.position))
        var additions: [TreeClusterRepresentable] = []
        var deletions: [YMKPlacemarkMapObject] = []
        for cluster in newClusters {
            if !objectPositions.contains(cluster.position) {
                additions.append(cluster)
            }
        }
        for object in currentClusterObjects {
            let position = TreePosition(latitude: object.geometry.latitude, longitude: object.geometry.longitude)
            if !clusterPositions.contains(position) {
                deletions.append(object)
            }
        }
        clusterChanges = .init(additions: additions, clusterDeletions: deletions, pointDeletions: currentTreeObjects)
        clusterChangesSubject.onNext(clusterChanges)
    }
}


// MARK: - YMKMapObjectVisitor

extension MapObjectsVisitor {
    
    func onPlacemarkVisited(withPlacemark placemark: YMKPlacemarkMapObject) {
        currentClusterObjects.append(placemark)
    }
    
    func onCircleVisited(withCircle circle: YMKCircleMapObject) {
        currentTreeObjects.append(circle)
    }
    
    func onCollectionVisitStart(with collection: YMKMapObjectCollection) -> Bool {
        return true
    }
    
    func onCollectionVisitEnd(with collection: YMKMapObjectCollection) {
        if isFilteringTrees {
            countTreeChanges()
        } else {
            countClustersChanges()
        }
    }
    
    func onClusterizedCollectionVisitStart(with collection: YMKClusterizedPlacemarkCollection) -> Bool {
        // unused
        return true
    }
    
    func onClusterizedCollectionVisitEnd(with collection: YMKClusterizedPlacemarkCollection) {
        // unused
    }
    
    func onPolylineVisited(withPolyline polyline: YMKPolylineMapObject) {
        // unused
    }
    
    func onColoredPolylineVisited(withPolyline polyline: YMKColoredPolylineMapObject) {
        // unused
    }
    
    func onPolygonVisited(withPolygon polygon: YMKPolygonMapObject) {
        // unused
    }
}
