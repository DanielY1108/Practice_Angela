//
//  News.swift
//  harcker New
//
//  Created by JinSeok Yang on 2022/11/08.
//

import Foundation

struct PostData: Codable {
    let hits: [Post]
}

struct Post: Codable, Identifiable {
    var id: String {
        return objectID
    }
    let objectID: String
    let title: String
    let points: Int
    let url: String?
}
