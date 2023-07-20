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
        } else if grades.isEmpty {
          TransientStatusNew(error: .gradesEmpty) {
            Task.init {
              await grades.update()
            }
          }
        } else {
          switch grades.error {
          case .networkError:
            TransientStatusNew(error: .networkError) {
              Task.init {
                await grades.update()
              }
            }
          case .serverError:
            TransientStatusNew(error: .serverError) {
              Task.init {
                await grades.update()
              }
            }
          case .none:
            if grades.data?.response == nil {
              TransientStatusNew(error: .gradesEmpty) {
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
