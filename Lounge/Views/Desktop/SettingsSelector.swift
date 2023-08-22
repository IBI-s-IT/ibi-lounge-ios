//
//  SettingsSelector.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 22.08.2023.
//

import SwiftUI

enum SettingsSections: String, Identifiable, CaseIterable {
  case schedules
  case grades
  
  var id: Self {
    return self
  }
  
  var title: String {
    switch self {
    case .grades:
      return "grades.data"
    case .schedules:
      return "settings.section.schedule"
    }
  }
  
  var icon: String {
    switch self {
    case .grades:
      return "graduationcap"
    case .schedules:
      return "calendar"
    }
  }
}

struct SettingsSelector: View {
  @Binding var settingsSection: SettingsSections?
  
  var body: some View {
    List(SettingsSections.allCases, selection: $settingsSection) { section in
      Label(LocalizedStringKey(section.title), systemImage: section.icon)
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
        .contentShape(Rectangle())
    }
    .navigationTitle("settings.title")
  }
}

struct SettingsSelector_Previews: PreviewProvider {
  static var previews: some View {
    SettingsSelector(settingsSection: .constant(.schedules))
  }
}
