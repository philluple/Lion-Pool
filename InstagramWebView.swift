//
//  InstagramWebView.swift
//  Lion Pool
//
//  Created by Phillip Le on 8/17/23.
//



import SwiftUI
import WebKit


struct InstagramWebView: UIViewRepresentable {
    
    var url = URL(string: "https://api.instagram.com/oauth/authorize?client_id=1326528034640707&redirect_uri=https://lion-pool.com/api/instagram-callback&scope=user_profile,user_media&response_type=code")
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
        
        // 3
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url!)
        webView.load(request)
    }
}
