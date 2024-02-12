//
//  DatabaseManager.swift
//  Gallery
//
//  Created by Егор Ярошук on 11.02.24.
//

import Foundation
import RealmSwift

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let realm = try! Realm()
    
    func addImage(imageId: String) {
        let dbImage = ImageDB(id: imageId)
        
        try? realm.write {
            realm.add(dbImage)
        }
    }
    
    func removeImage(imageId: String) {
        guard let image = realm.objects(ImageDB.self).first(where: {$0.id == imageId}) else { return }
        try? realm.write {
            realm.delete(image)
        }
    }
    
    func getStoredImages() -> [String] {
        realm.objects(ImageDB.self).map({$0.id})
    }
}
