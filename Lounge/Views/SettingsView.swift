//
//  Settings.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 06.08.2023.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var settings: SettingsModel;
  @State var groups: GroupsResult = .error(.loading);
  
  private enum Tabs: Hashable {
    case schedules, grades
  }
  
  var body: some View {
#if os(iOS)
    List {
      SchedulesSettings()
      GradesSettings()
    }
    .task {
      await updateGroups()
    }
    .refreshable {
      await updateGroups()
    }
    .navigationTitle("settings.title")
#else
    TabView {
      Form {
        SchedulesSettings()
      }
      .tabItem {
        Label("main.title", systemImage: "calendar")
      }
      .tag(Tabs.schedules)
      Form {
        GradesSettings()
      }
      .tabItem {
        Label("grades.title", systemImage: "person.text.rectangle")
      }
      .tag(Tabs.grades)
    }
    .padding()
    .frame(width: 375, height: 150)
#endif
  }
  
  func updateGroups() async {
    groups = await Requests().fetchGroups(educationLevel: settings.educationLevel)
  }
}

#Preview {
  SettingsView()
    .environmentObject(SettingsModel())
}
