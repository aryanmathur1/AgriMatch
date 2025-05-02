//
//  ConsumerTabView.swift
//  FarmerApp
//
//  Created by vibhun naredla on 3/22/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var path = NavigationPath()
    @State private var tabSelection = 1
    @State private var hideParentTabBar = false
    @State private var showTabBar = true

    var body: some View {
        TabView(selection: $tabSelection) {
            HomeView(tabSelection: $tabSelection, showTabBar: $showTabBar, path: $path)
                .background {
                    if !hideParentTabBar {
                        HideTabView { hideParentTabBar = true }
                    }
                }
                .tag(1)

            TipsView2(tabSelection: $tabSelection, showTabBar: $showTabBar, path: $path)
                .tag(2)
            SwipeView()
                .tag(3)
            WeatherView()
                .tag(4)
            ProfileView()
                .tag(5)
        }
        .overlay(alignment: .bottom) {
            if showTabBar {
                CustomTabBar(tabSelection: $tabSelection)
            }
        }
        .ignoresSafeArea()
    }
}
