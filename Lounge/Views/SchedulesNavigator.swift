//
//  RaspisanNavigationView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 23.06.2023.
//

import SwiftUI

struct SchedulesNavigator: View {
  
  var body: some View {
    NavigationView {
      Schedules(from: Date().startOfWeek, to: Date().startOfNextWeek, isEmbedded: true)
        .navigationTitle("main.title")
#if os(macOS)
        .listStyle(.sidebar)
#endif
    }
  }
}

struct SchedulesNavigator_Previews: PreviewProvider {
  static var previews: some View {
    SchedulesNavigator()
      .environmentObject(SettingsModel())
  }
}

