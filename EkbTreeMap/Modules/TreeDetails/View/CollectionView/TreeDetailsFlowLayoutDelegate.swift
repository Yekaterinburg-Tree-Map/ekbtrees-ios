//
//  TreeDetailsFlowLayoutDelegate.swift
//  EkbTreeMap
//
//  Created by s.petrov on 10.05.2021.
//

import UIKit


final class TreeDetailsFlowLayoutDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    // MARK: Public Properties
    
    var itemsPerRow: CGFloat = 5
    var sectionInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    
    
    // MARK: Public
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
      ) -> CGSize {
        // 2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
      }
      
      // 3
      func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
      ) -> UIEdgeInsets {
        return sectionInsets
      }
      
      // 4
      func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
      ) -> CGFloat {
        return sectionInsets.left
      }
}
