//
//  GradesSettings.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 10.08.2023.
//

import SwiftUI

struct GradesSettings: View {
  @EnvironmentObject var settings: SettingsModel;
  var sectionHidden: Bool = false
  
  var body: some View {
    Section("grades.data") {
      VStack(alignment: .leading) {
        LabeledContent("grades.pin") {
          TextField("grades.pin", text: $settings.pin)
            .autocorrectionDisabled(true)
            .multilineTextAlignment(.trailing)
#if os(macOS)
            .labelsHidden()
#endif
        }
        Group {
          switch settings.pinValidity {
          case .empty:
            Text("valid.pin_empty")
          case .count:
            Text("valid.pin_length")
          case .okay:
            EmptyView()
          }
        }
        .font(.caption)
        .foregroundStyle(.red)
      }
      VStack(alignment: .leading) {
        LabeledContent("grades.lastName") {
          TextField("grades.lastName", text: $settings.lastName)
#if os(macOS)
            .labelsHidden()
#endif
            .multilineTextAlignment(.trailing)
        }
        Group {
          switch settings.lastNameValidity {
          case .empty:
            Text("valid.last_name_empty")
          case .count:
            Text("valid.last_name_length")
          case .okay:
            EmptyView()
          }
        }
        .font(.caption)
        .foregroundStyle(.red)
      }
    }
  }
}

struct GradesSettings_Previews: PreviewProvider {
  static var previews: some View {
    List {
      GradesSettings()
        .environmentObject(SettingsModel())
    }
  }
}
