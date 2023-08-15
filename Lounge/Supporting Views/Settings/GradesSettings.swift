//
//  GradesSettings.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 10.08.2023.
//

import SwiftUI

struct GradesSettings: View {
  @EnvironmentObject var settings: SettingsModel;

  var body: some View {
    Section("grades.data") {
      VStack(alignment: .leading) {
        TextField("grades.pin", text: $settings.pin)
          .autocorrectionDisabled(true)
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
        TextField("grades.lastName", text: $settings.lastName)
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

#Preview {
  List {
    GradesSettings()
      .environmentObject(SettingsModel())
  }

}
