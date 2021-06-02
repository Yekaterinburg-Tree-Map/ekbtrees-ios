//
//  MapVisibleAreaToTilesConverter.swift
//  EkbTreeMap
//
//  Created by s.petrov on 26.05.2021.
//

import Foundation


protocol AreaToTilesConverting {
    
    func processVisibleArea(_ area: MapViewVisibleRegionPoints) -> MapViewVisibleTiles
    func processTile(from point: TreePosition, zoom: Int) -> MapViewTile
}


final class MapVisibleAreaToTilesConverter: AreaToTilesConverting {
    
    // MARK: Public
    
    func processVisibleArea(_ area: MapViewVisibleRegionPoints) -> MapViewVisibleTiles {
        let cornerTiles = [area.topLeft, area.bottomRight].map {
            processTile(from: $0, zoom: area.zoom)
        }
        let tiles: Set<MapViewTile> = {
            var result = Set<MapViewTile>()
            let minX = min(cornerTiles.first!.x, cornerTiles.last!.x)
            let maxX = max(cornerTiles.first!.x, cornerTiles.last!.x)
            for x in (minX...maxX) {
                let minY = min(cornerTiles.first!.y, cornerTiles.last!.y)
                let maxY = max(cornerTiles.first!.y, cornerTiles.last!.y)
                for y in (minY...maxY) {
                    result.update(with: MapViewTile(x: x, y: y, zoom: area.zoom))
                }
            }
            return result
        }()
        let corner = findCornerTiles(tiles)
        let topLeft = findTilePosition(MapViewTile(x: corner.0.x - 2,
                                                   y: corner.0.y - 2,
                                                   zoom: area.zoom))
        let bottomRight = findTilePosition(MapViewTile(x: corner.0.x + 2,
                                                       y: corner.0.y + 2,
                                                       zoom: area.zoom))
        
        return MapViewVisibleTiles(tiles: Array(tiles),
                                   topLeftPosition: topLeft,
                                   bottomRightPosition: bottomRight,
                                   zoom: area.zoom)
    }
    
    func processTile(from point: TreePosition, zoom: Int) -> MapViewTile {
        let longitude = point.longitude
        let latitude = point.latitude
        let tileX = Int(floor((longitude + 180) / 360.0 * pow(2.0, Double(zoom))))
        let tileY = Int(floor((1 - log(tan(latitude * Double.pi / 180.0) + 1 / cos(latitude * Double.pi / 180.0)) / Double.pi) / 2 * pow(2.0, Double(zoom))))
        
        return MapViewTile(x: tileX, y: tileY, zoom: zoom)
    }
    
    
    // MARK: Private
    
    private func findTilePosition(_ tile: MapViewTile) -> TreePosition {
        let x: Int = max(tile.x, 0)
        let y: Int = max(tile.y, 0)
        let n : Double = pow(2.0, Double(tile.zoom))
        let lon = (Double(x) / n) * 360.0 - 180.0
        let lat = atan(sinh(.pi - (Double(y) / n) * 2 * Double.pi)) * (180.0 / .pi)
        
        return TreePosition(latitude: lat, longitude: lon)
    }
    
    private func findCornerTiles(_ tiles: Set<MapViewTile>) -> (MapViewTile, MapViewTile) {
        let sorted = tiles.sorted(by: <)
        guard let first = sorted.first, let last = sorted.last else {
            return (tiles.first!, tiles.first!)
        }
        
        return (first, last)
    }
}
