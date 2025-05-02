//
//  ContentView.swift
//  FarmerApp
//
//  Created by vibhun naredla on 3/22/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var hasFinishedOnboarding: Bool = false

    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MainTabView()
            } else if viewModel.userSession == nil {
                if !hasFinishedOnboarding {
                    IntroView {
                        hasFinishedOnboarding = true
                    }
                } else {
                    LoginView()
                }
            }
        }
    }
}

