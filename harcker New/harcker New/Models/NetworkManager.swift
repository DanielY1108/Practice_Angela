//
//  NetworkManager.swift
//  harcker New
//
//  Created by JinSeok Yang on 2022/11/08.
//

import Foundation

class NetworkManager: ObservableObject {
    
    static let shared = NetworkManager()
    
    @Published var post = [Post]()
        
    func fetchData() {
        if let url = URL(string: "http://hn.algolia.com/api/v1/search?tags=front_page") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error?.localizedDescription ?? "Error: URL")
                }
                guard let safeData = data else {
                    print("Error: Data")
                    return
                }
                do {
                    let result = try JSONDecoder().decode(PostData.self, from: safeData)
                    DispatchQueue.main.async {
                        self.post = result.hits
                    }
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
    }
}
