//
//  GradesView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 24.06.2023.
//

import SwiftUI

struct GradesView: View {
  @EnvironmentObject var grades: GradesModel
  
  var body: some View {
    NavigationStack {
      List {
        if grades.isLoading {
          ProgressView()
        } else if grades.error != nil {
          TransientStatusNew(error: grades.error!) {
            Task.init {
              await grades.update()
            }
          }
        } else {
          Section("grades.grades") {
            ForEach(grades.data!.response) { grade in
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
          }
        }
      }
      .refreshable {
        Task.init {
          await grades.update();
        }
      }
      .navigationTitle("grades.title")
    }
  }
}

#Preview {
  GradesView()
    .environmentObject(GradesModel())
}
