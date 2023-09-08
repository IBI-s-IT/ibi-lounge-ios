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
  @State var taskId: UUID = .init()
  
  func content() -> AnyView {
    switch grades {
    case .result(let result):
      return AnyView(List {
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
      })
    case .error(let error):
      return AnyView(TransientStatusNew(error: error) {
        taskId = .init()
      })
    }
  }
  
  var body: some View {
    NavigationStack {
      content()
        .task(id: taskId) {
          await fetch()
        }
        .refreshable {
          taskId = .init()
        }
        .navigationTitle("grades.title")
    }
  }
  
  func fetch() async {
    self.grades = .error(.loading)
    grades = await Requests().fetchGrades(pin: settings.pin, lastName: settings.lastName)
  }
}

struct Grades_Previews: PreviewProvider {
  static var previews: some View {
    GradesView()
      .environmentObject(SettingsModel())
  }
}
