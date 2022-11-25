//
//  ContentView.swift
//  harcker New
//
//  Created by JinSeok Yang on 2022/11/08.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var networkManager = NetworkManager.shared
    
    func manymany(completion: () -> Void) {
        print("Aa")
        completion()
    }
    
    var body: some View {
        NavigationView {
            List(networkManager.post) { post in
                NavigationLink(destination: DetailView(url: post.url)) {
                    HStack {
                        Text(String(post.points))
                        Text(post.title)
                    }
                }
            }
            .navigationTitle("Hacker New")
            .listStyle(.plain)
            
        }
        .onAppear {
            self.networkManager.fetchData()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
