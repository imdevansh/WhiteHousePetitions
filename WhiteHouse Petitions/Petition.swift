//
//  Petition.swift
//  WhiteHouse Petitions
//
//  Created by GGS-BKS on 11/10/22.
//

import Foundation
struct Petition:Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
