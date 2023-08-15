//
//  SchedulesSettings.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 10.08.2023.
//

import SwiftUI

struct SchedulesSettings: View {
  @EnvironmentObject var settings: SettingsModel;
  @State var groups: GroupsResult = .error(.loading);
  
  var body: some View {
    Section("settings.section.schedule") {
      Picker("settings.education_level", selection: $settings.educationLevel) {
        ForEach(EducationLevel.allCases, id: \.self) { eduLevel in
          Text(LocalizedStringKey(String(eduLevel.rawValue))).tag(eduLevel)
        }
      }
      .onChange(of: settings.educationLevel) { newEdu in
        Task.init {
          await updateGroups()
        }
      }
      switch groups {
      case .result(let result):
        Picker("settings.group_selection", selection: $settings.group) {
          ForEach(result.response, id: \.id) { group in
            Text(group.name).tag(group.id)
          }
        }
      case .error(let error):
        TransientStatusNew(error: error) {
          Task.init {
            await updateGroups()
          }
        }
      }
    }
    .task {
      await updateGroups()
    }
    .refreshable {
      await updateGroups()
    }
  }
  
  func updateGroups() async {
    groups = await Requests().fetchGroups(educationLevel: settings.educationLevel)
  }
}

#Preview {
  List {
    SchedulesSettings()
  }
  .environmentObject(SettingsModel())
}
