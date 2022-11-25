//
//  WebView.swift
//  harcker New
//
//  Created by JinSeok Yang on 2022/11/09.
//

import Foundation
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    
    let urlString: String?
    
    // 초기 상태 구성
    func makeUIView(context: Context) -> WebView.UIViewType {
        return WKWebView()
    }
    // 새로운 정보로 지정된 뷰의 상태를 업데이트 uiView에서 업데이트할 항목을 WKWebView를 통해 업데이트
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let safeUrl = urlString {
            if let url = URL(string: safeUrl) {
                let request = URLRequest(url: url)
                uiView.load(request)
            }
        }
    }
    
}
