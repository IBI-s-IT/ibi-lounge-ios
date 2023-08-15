//
//  AppNavigator.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 06.08.2023.
//

import SwiftUI

struct AppNavigator: View {
  var body: some View {
    NavigationView {
      List {
        Section("main.title") {
          NavigationLink {
            Schedules(from: Date().startOfWeek, to: Date().endOfWeek, periodName: "main.this_week")
          } label: {
            Text("main.this_week")
          }
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
        }
        Section {
          NavigationLink {
            GradesView()
          } label: {
            Label("grades.title", systemImage: "list.number")
          }
          NavigationLink {
            LMSView()
          } label: {
            Label("lms.title", systemImage: "doc")
          }
#if os(iOS)
          NavigationLink {
            SettingsView()
          } label: {
            Label("settings.title", systemImage: "gearshape")
          }
#endif
        }
      }
      .listStyle(.sidebar)
#if os(macOS)
      .toolbar {
        ToolbarItem {
          if #available(macOS 14, *) {
            SettingsLink(label: {
              Label("settings.title", systemImage: "gearshape")
            })
          } else {
            Button("settings.title", systemImage: "gearshape") {
              if #available(macOS 13, *) {
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
              } else {
                NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
              }
            }
          }
        }
      }
#endif
      .navigationTitle("Lounge")
      
      Schedules(from: Date().startOfWeek, to: Date().endOfWeek, periodName: "main.this_week")
    }
  }
}

#Preview {
  AppNavigator()
}
