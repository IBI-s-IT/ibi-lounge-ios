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
        NavigationLink {
          Settings()
        } label: {
          Label("settings.title", systemImage: "gearshape")
        }
      }
      .listStyle(.sidebar)
      .navigationTitle("Lounge")
    }
  }
}

#Preview {
  AppNavigator()
}
