//
//  RaspisanNavigationView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 23.06.2023.
//

import SwiftUI

struct SchedulesNavigator: View {
  let thisWeek = Schedules(from: Date().startOfWeek, to: Date().startOfNextWeek, isEmbedded: true)
  
  var body: some View {
    NavigationView {
      List {
        NavigationLink {
          Schedules(from: Date().startOfNextWeek, to: Date().endOfNextWeek, periodName: "main.next_week")
        } label: {
          Text("main.next_week")
        }
        NavigationLink {
          Schedules(from: Date().startOfMonth(), to: Date().endOfMonth(), periodName: "main.this_month")
        } label: {
          Text("main.this_month")
        }
        NavigationLink {
          Schedules(from: .now, to: .now, periodName: "main.custom_range", isCustomPeriod: true)
        } label: {
          Text("main.custom_range")
        }
        Section("main.this_week") {
          thisWeek
        }
      }
      .navigationTitle("main.title")
      #if os(macOS)
      .listStyle(.sidebar)
      #endif
    }
  }
}

#Preview {
  SchedulesNavigator()
    .environmentObject(SettingsModel())
}
