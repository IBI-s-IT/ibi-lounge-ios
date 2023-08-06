//
//  GradesView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 24.06.2023.
//

import SwiftUI

struct GradesView: View {
  @EnvironmentObject var settings: SettingsModel;
  @State var grades: GradesResult = .error(.loading)
  
  var body: some View {
    List {
      switch grades {
      case .result(let result):
        ForEach(result.response) { grade in
          HStack {
            VStack(alignment: .leading, content: {
              Text(grade.name)
              Text(LocalizedStringKey(grade.type.rawValue))
                .font(.caption)
            })
            Spacer()
            Text(LocalizedStringKey(grade.grade.rawValue))
              .foregroundStyle(.secondary)
          }
        }
      case .error(let error):
        TransientStatusNew(error: error) {
          Task.init {
            await fetch()
          }
        }
      }
    }
    .task {
      await fetch()
    }
    .refreshable {
      await fetch()
    }
    .navigationTitle("grades.title")
  }
  
  func fetch() async {
    grades = await Requests().fetchGrades(pin: settings.pin, lastName: settings.lastName)
  }
}

#Preview {
  GradesView()
    .environmentObject(SettingsModel())
}
