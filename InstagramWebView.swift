//
//  InstagramWebView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/17/23.
//



import SwiftUI
import WebKit


struct InstagramWebView: UIViewRepresentable {
    var url = URL(string: "https://api.instagram.com/oauth/authorize?client_id=1326528034640707&redirect_uri=https://876e-47-147-92-55.ngrok-free.app/instagram-callback&scope=user_profile,user_media&response_type=code")

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
        
        // 3
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url!)
        webView.load(request)
    }
//    class Coordinator: NSObject, WKNavigationDelegate {
//        var parent: InstagramWebView
//
//        init(_ parent: InstagramWebView) {
//            self.parent = parent
//        }
//
//        // This method is called when a navigation starts
//        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
//                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            // Check if this is the redirect_uri
//            if let url = navigationAction.request.url,
//               url.absoluteString.starts(with: "https://google.com") {
//                parent.responseURL = url
//                decisionHandler(.cancel) // Stop loading the page
//                return
//            }
//            decisionHandler(.allow) // Allow loading other pages
//        }
//    }
}
