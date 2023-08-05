//
//  raspisansuApp.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 17.06.2023.
//

import SwiftUI

@main
struct LoungeApp: App {
  @StateObject var grades = GradesModel()
  @StateObject var groups = GroupsModel()
  @StateObject var raspisan = SchedulesModel()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(grades)
        .environmentObject(groups)
        .environmentObject(raspisan)
    }
    .commands {
      SidebarCommands()
    }
#if os(macOS)
    Settings {
      SettingsView()
        .environmentObject(grades)
        .environmentObject(groups)
        .environmentObject(raspisan)
    }
#endif
  }
}
