//
//  Category.swift
//  Todoey
//
//  Created by JINSEOK on 2022/11/12.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorName: String = ""
    
    // 정방향 릴레이션 설정하는 방법
    // List는 Realm에서 일종의 배열이다 (ex. Array<Int> 배열의 타입 같다)
    let items = List<Item>()

 
}
