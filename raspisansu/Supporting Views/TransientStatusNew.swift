//
//  TransientStatusNew.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 25.06.2023.
//

import SwiftUI

enum TransientStatusErrors {
  case networkError
  case serverError
  case badError
  case schedulesEmpty
  case gradesEmpty
  case groupsEmpty
}

struct TransientStatusNew: View {
  var error: TransientStatusErrors?
  var action: (() -> Void)?

  var body: some View {
    switch error {
    case .networkError,
        .serverError,
        .badError,
        .schedulesEmpty,
        .gradesEmpty,
        .groupsEmpty:
      ContentUnavailableView(label: {
        switch error {
        case .networkError:
          Label("error.no_network", systemImage: "wifi.slash")
        case .serverError:
          Label("error.unknown_error", systemImage: "questionmark.app.dashed")
        case .badError:
          Label("error.unknown_error", systemImage: "questionmark.app.dashed")
        case .schedulesEmpty:
          Label("error.no_schedule", systemImage: "exclamationmark.bubble")
        case .gradesEmpty:
          Label("error.no_grades", systemImage: "exclamationmark.bubble")
        case .groupsEmpty:
          Label("error.no_groups", systemImage: "exclamationmark.bubble")
        case nil:
          HStack(alignment: .center, content: {
            Spacer()
            ProgressView()
            Spacer()
          })
          .padding()
        }
      }, description: {
        switch error {
        case .networkError:
          Text("error.no_network.desc")
        case .serverError:
          Text("error.unknown_error.desc")
        case .badError:
          Text("error.unknown_error.desc")
        case .schedulesEmpty:
          Text("error.no_schedule.desc")
        case .gradesEmpty:
          Text("error.no_grades.desc")
        case .groupsEmpty:
          Text("error.no_groups.desc")
        case nil:
          HStack(alignment: .center, content: {
            Spacer()
            ProgressView()
            Spacer()
          })
          .padding()
        }
      }, actions: {
        if action != nil {
          Button("error.try_again") {
            action?()
          }
        }
      })
    case nil:
      HStack(alignment: .center, content: {
        Spacer()
        ProgressView()
        Spacer()
      })
      .padding()
    }
  }
}

#Preview {
  ScrollView {
    TransientStatusNew(error: .networkError) {
      print("try")
    }
    TransientStatusNew(error: .serverError)
    TransientStatusNew(error: .badError)
    TransientStatusNew(error: .schedulesEmpty)
    TransientStatusNew(error: .groupsEmpty)
    TransientStatusNew(error: .gradesEmpty)
  }
  .environment(\.locale, .init(identifier: "ru"))
}

#Preview {
  ScrollView {
    TransientStatusNew(error: .networkError)
    TransientStatusNew(error: .serverError)
    TransientStatusNew(error: .badError)
    TransientStatusNew(error: .schedulesEmpty)
    TransientStatusNew(error: .groupsEmpty)
    TransientStatusNew(error: .gradesEmpty)
  }
  .environment(\.locale, .init(identifier: "en"))
}
