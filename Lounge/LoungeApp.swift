//
//  raspisansuApp.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 17.06.2023.
//

import SwiftUI

@main
struct LoungeApp: App {
  @StateObject var settings = SettingsModel()
  @StateObject var weekStore = WeekStore()
  @StateObject var webView = WebViewModel()
  
  var body: some Scene {
    WindowGroup {
      if let defaults = UserDefaults(suiteName: "group.space.utme.raspisansu.shared") {
        ContentView()
          .defaultAppStorage(defaults)
          .environmentObject(settings)
          .environmentObject(weekStore)
          .environmentObject(webView)
      } else {
        Text("Failed to load defaults")
      }
    }
    .commands {
      SidebarCommands()
    }
#if os(macOS)
      Settings {
        SettingsView()
          .environmentObject(settings)
      }
#endif
    }
  }
