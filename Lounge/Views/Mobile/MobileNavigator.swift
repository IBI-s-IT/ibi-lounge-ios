//
//  MobileNavigator.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 21.08.2023.
//

import SwiftUI

struct MobileNavigator: View {
  var body: some View {
    TabView {
      SchedulesDayNavigator()
        .tabItem {
          Label("main.title", systemImage: "calendar")
        }
      NavigationView {
        LMSView()
      }
      .tabItem {
        Label("materials.title", systemImage: "newspaper")
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
  }
}

struct MobileNavigator_Previews: PreviewProvider {
  static var previews: some View {
    MobileNavigator()
      .environment(\.locale, .init(identifier: "ru"))
      .environmentObject(SettingsModel())
      .environmentObject(WeekStore())
  }
}
