//
//  ContentView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 17.06.2023.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    if UIDevice.current.userInterfaceIdiom == .pad {
      AppNavigator()
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
          Settings()
        }
        .tabItem {
          Label("settings.title", systemImage: "gearshape")
        }
      }
    }
    
  }
}

#Preview {
  ContentView()
    .environment(\.locale, .init(identifier: "ru"))
    .environmentObject(SettingsModel())
}
