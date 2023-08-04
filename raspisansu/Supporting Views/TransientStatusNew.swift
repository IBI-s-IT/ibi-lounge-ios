//
//  TransientStatusNew.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 25.06.2023.
//

import SwiftUI

struct TransientStatusNew: View {
  var error: Errors
  var action: (() -> Void)?
  
  var body: some View {
    ErrorScreen(icon: error.icon, title: error.title, description: error.description, code: error.rawValue, action: action)
  }
}

#Preview {
  ScrollView {
    TransientStatusNew(error: .network_error) {
      print("try")
    }
    TransientStatusNew(error: .bad_error)
    TransientStatusNew(error: .no_schedules)
    TransientStatusNew(error: .no_groups)
    TransientStatusNew(error: .no_grades)
    TransientStatusNew(error: .no_education_level_specified)
    TransientStatusNew(error: .timed_out)
    TransientStatusNew(error: .unknown_error)
  }
  .environment(\.locale, .init(identifier: "ru"))
}
