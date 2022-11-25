//
//  Item.swift
//  Todoey
//
//  Created by JINSEOK on 2022/11/12.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    @objc dynamic var color: String = ""
    
    // 역방향 릴레이션 설정 방법
    // type을 역방향 모델의 메타타입으로 설정, property 정방향 릴레이션의 속성의 이름
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
