//
//  UploadingPhotoEntity.swift
//  EkbTreeMap
//
//  Created by s.petrov on 05.06.2021.
//

import RealmSwift
import Foundation


class UploadingPhotoEntity: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var data = Data()
    @objc dynamic var treeId: Int = 0
    @objc dynamic var uploadStatus: String = ""
    
    static override func primaryKey() -> String? {
        "id"
    }
}
