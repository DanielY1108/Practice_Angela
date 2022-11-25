//
//  DetailView.swift
//  harcker New
//
//  Created by JinSeok Yang on 2022/11/09.
//

import SwiftUI

struct DetailView: View {
    
    let url: String?
    
    var body: some View {
        WebView(urlString: url)
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https:www.google.com")
    }
}
