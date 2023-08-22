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
      ContentView()
        .environmentObject(settings)
        .environmentObject(weekStore)
        .environmentObject(webView)
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
