//
//  SettingsView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 19.06.2023.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var groups: GroupsModel;
  @EnvironmentObject var grades: GradesModel;
  
  var body: some View {
    List {
      Section("settings.section.schedule") {
        Picker("settings.education_level", selection: $groups.educationLevel) {
          ForEach(EducationLevel.allCases, id: \.self) { eduLevel in
            Text(LocalizedStringKey(String(eduLevel.rawValue))).tag(eduLevel)
          }
        }
        if groups.isLoading {
          TransientStatusNew(error: .none);
        } else {
          switch groups.error {
          case .networkError:
            TransientStatusNew(error: .networkError) {
              Task.init {
                await groups.update()
              }
            }
          case .serverError:
            TransientStatusNew(error: .serverError) {
              Task.init {
                await groups.update()
              }
            }
          case .none:
            if groups.data?.response != nil {
              Picker("settings.group_selection", selection: $groups.group) {
                ForEach(groups.data!.response, id: \.id) { grp in
                  Text(grp.name).tag(grp.id)
                }
              }
            }
          }
        }
      }
      Section("grades.data") {
        VStack(alignment: .leading) {
          TextField("grades.pin", text: $grades.pin)
            .autocorrectionDisabled(true)
          if grades.validationStatus == .pinEmpty {
            Text("valid.pin_empty")
              .font(.caption)
              .foregroundStyle(.red)
          }
          if grades.validationStatus == .pinCount {
            Text("valid.pin_length")
              .font(.caption)
              .foregroundStyle(.red)
          }
        }
        VStack(alignment: .leading) {
          TextField("grades.lastName", text: $grades.lastName)
          if grades.validationStatus == .lastNameEmpty {
            Text("valid.last_name_empty")
              .font(.caption)
              .foregroundStyle(.red)
          }
          if grades.validationStatus == .lastNameCount {
            Text("valid.last_name_length")
              .font(.caption)
              .foregroundStyle(.red)
          }
        }
      }
    }
#if os(iOS)
    .listStyle(.insetGrouped)
#endif
    .navigationTitle("settings.title")
  }
}

#Preview {
  NavigationStack {
    SettingsView()
      .environmentObject(GroupsModel())
      .environmentObject(GradesModel())
  }
}
