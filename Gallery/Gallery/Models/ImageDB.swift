//
//  ImageDB.swift
//  Gallery
//
//  Created by Егор Ярошук on 11.02.24.
//

import RealmSwift

class ImageDB: Object {
    @Persisted (primaryKey: true) var id: String
    
    convenience init(id: String) {
        self.init()
        self.id = id
    }
}
