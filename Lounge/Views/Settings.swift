//
//  Settings.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 06.08.2023.
//

import SwiftUI

struct Settings: View {
  @EnvironmentObject var settings: SettingsModel;
  @State var groups: GroupsResult = .error(.loading);
  
  var body: some View {
    List {
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
      Section("grades.data") {
        VStack(alignment: .leading) {
          TextField("grades.pin", text: $settings.pin)
            .autocorrectionDisabled(true)
          switch settings.pinValidity {
          case .empty:
            Text("valid.pin_empty")
              .font(.caption);
          case .count:
            Text("valid.pin_length")
              .font(.caption);
          case .okay:
            EmptyView()
          }
        }
        VStack(alignment: .leading) {
          TextField("grades.lastName", text: $settings.lastName)
          switch settings.lastNameValidity {
          case .empty:
            Text("valid.last_name_empty")
              .font(.caption);
          case .count:
            Text("valid.last_name_length")
              .font(.caption);
          case .okay:
            EmptyView()
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
    .navigationTitle("settings.title")
  }
  
  func updateGroups() async {
    groups = await Requests().fetchGroups(educationLevel: settings.educationLevel)
  }
}

#Preview {
  Settings()
    .environmentObject(SettingsModel())
}
