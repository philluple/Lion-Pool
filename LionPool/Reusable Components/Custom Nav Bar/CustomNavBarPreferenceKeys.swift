//
//  CustomNavBarPreferenceKeys.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/20/23.
//

import Foundation
import SwiftUI

struct CustomNavBarTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct CustomNavBarTitleFontSize: PreferenceKey{
    static var defaultValue: CGFloat = 20
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CustomNavBarBackButtonHidden: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

extension View {
//    .navigationTitle("Title 2")
//    .navigationBarBackButtonHidden(false)
    func customNavigationTitle(_ title: String)->some View{
        preference(key: CustomNavBarTitlePreferenceKey.self, value: title)
    }
    func customNavigationSize(_ fontSize: CGFloat)->some View{
        preference(key: CustomNavBarTitleFontSize.self, value: fontSize)
    }
    func customNavigationHidden(_ hidden: Bool)->some View{
        preference(key: CustomNavBarBackButtonHidden.self, value: hidden)
    }
    
    func customNavBarItems(title: String = "", fontSize: CGFloat = 12, backButtonHidden: Bool = false) -> some View
    {
        self
            .customNavigationTitle(title)
            .customNavigationSize(fontSize)
            .customNavigationHidden(backButtonHidden)
    }
}
