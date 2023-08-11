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
}

#Preview {
  GradesSettings()
    .environmentObject(SettingsModel())
}
