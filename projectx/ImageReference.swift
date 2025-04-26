//
//  ImageReference.swift
//  projectx
//
//  Created by jeboy on 26/04/25.
//

import Foundation
import FirebaseFirestore

struct ImageReference: Identifiable, Codable {
    var id: String
    var referenceName: String
    var imageUrl: String
    var timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case referenceName
        case imageUrl
        case timestamp
    }
}
