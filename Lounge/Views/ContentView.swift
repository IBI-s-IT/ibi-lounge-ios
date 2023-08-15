//
//  ContentView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 17.06.2023.
//

import SwiftUI


struct ContentView: View {
  @AppStorage("showOnboarding2") var showOnboarding = true;
  var body: some View {
#if os(macOS)
    AppNavigator()
      .sheet(isPresented: $showOnboarding, content: {
        OnboardingSheet()
      })
#else
    if UIDevice.current.userInterfaceIdiom == .pad {
      AppNavigator()
        .sheet(isPresented: $showOnboarding) {
          OnboardingSheet()
        }
    } else {
      TabView {
        SchedulesNavigator()
          .tabItem {
            Label("main.title", systemImage: "calendar")
          }
        NavigationStack {
          LMSView()
        }
        .tabItem {
          Label("lms.title", systemImage: "list.bullet.below.rectangle")
        }
        NavigationStack {
          GradesView()
        }
        .tabItem {
          Label("grades.title", systemImage: "graduationcap")
        }
        NavigationStack {
          SettingsView()
        }
        .tabItem {
          Label("settings.title", systemImage: "gearshape")
        }
      }
      .sheet(isPresented: $showOnboarding, content: {
        OnboardingSheet()
      })
    }
#endif
  }
}

#Preview {
  ContentView()
    .environment(\.locale, .init(identifier: "ru"))
    .environmentObject(SettingsModel())
}
