//
//  DisneyCharactersApp.swift
//  DisneyCharacters
//
//  Created by Lucas Hinova on 27/11/24.
//

import SwiftUI

@main
struct DisneyCharactersApp: App {
    @State private var showHome = false

    var body: some Scene {
        WindowGroup {
            if showHome {
                HomeView()
            } else {
                SplashScreenView {
                    withAnimation {
                        showHome = true
                    }
                }
            }
        }
    }
}
