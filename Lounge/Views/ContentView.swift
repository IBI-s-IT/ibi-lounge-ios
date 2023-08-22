//
//  ContentView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 17.06.2023.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("showOnboarding2") var showOnboarding = true
  
  var body: some View {
#if os(macOS)
    DeskNavigator()
      .sheet(isPresented: $showOnboarding, content: {
        OnboardingSheet()
      })
#else
    if UIDevice.current.userInterfaceIdiom == .pad {
      DeskNavigator()
        .sheet(isPresented: $showOnboarding) {
          OnboardingSheet()
        }
    } else {
      MobileNavigator()
        .sheet(isPresented: $showOnboarding) {
          OnboardingSheet()
        }
    }
#endif
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environment(\.locale, .init(identifier: "ru"))
      .environmentObject(SettingsModel())
      .environmentObject(WeekStore())
  }
}
