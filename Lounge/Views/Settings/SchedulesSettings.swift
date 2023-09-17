//
//  SchedulesSettings.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 10.08.2023.
//

import SwiftUI
import WidgetKit

struct SchedulesSettings: View {
  @EnvironmentObject var settings: SettingsModel
  @State var levels: LevelsResult = .error(.loading)
  @State var groups: GroupsResult = .error(.loading)
  
  var body: some View {
    Section("settings.section.schedule") {
      switch levels {
      case .result(let levels):
        Picker("settings.education_level", selection: $settings.educationLevel) {
          ForEach(levels.response, id: \.id) { level in
            Text(level.name).tag(level.id)
          }
        }
        .onChange(of: settings.educationLevel) { _ in
          Task.init {
            await updateGroups()
          }
        }
      case .error(let errors):
        TransientStatusNew(error: errors) {
          Task.init {
            await updateLevels()
          }
        }
      }
      switch groups {
      case .result(let result):
        Picker("settings.group_selection", selection: $settings.group) {
          ForEach(result.response, id: \.id) { group in
            Text(group.name).tag(group.id)
          }
        }
        .onChange(of: settings.group) { newValue in
          let defaults = UserDefaults(suiteName: "group.space.utme.raspisansu.shared")
          defaults!.set(newValue, forKey: "group")
          WidgetCenter.shared.reloadAllTimelines()
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
      await updateLevels();
      await updateGroups();
    }
  }
  
  func updateGroups() async {
    groups = await Requests().fetchGroups(level_id: settings.educationLevel)
  }
  
  func updateLevels() async {
    levels = await Requests().fetchLevels()
  }
}

struct SchedulesSettings_Previews: PreviewProvider {
  static var previews: some View {
    List {
      SchedulesSettings()
    }
    .environmentObject(SettingsModel())
  }
}
