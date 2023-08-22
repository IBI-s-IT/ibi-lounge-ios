//
//  Schedules.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 06.08.2023.
//

import SwiftUI

struct Schedules: View {
  @Binding var from: Date
  @Binding var to: Date
  var periodName: String?;
  @EnvironmentObject var settings: SettingsModel;
  @State var days: DaysRequestResult = .error(.loading);
  @State private var taskId: UUID = .init()
  
  func content() -> AnyView {
    switch days {
    case .response(let result):
      return AnyView(List {
        ForEach(result.response!, id: \.self.date) { day in
          DayView(
            day: day
          )
        }
      })
    case .error(let error):
      return AnyView(TransientStatusNew(error: error) {
        taskId = .init()
      })
    }
  }
  
  var body: some View {
    content()
      .onChange(of: from, perform: { value in
        taskId = .init()
      })
      .onChange(of: to, perform: { value in
        taskId = .init()
      })
      .task(id: taskId) {
        await fetch()
      }
      .refreshable {
        taskId = .init()
      }
      .navigationTitle(periodName != nil ? LocalizedStringKey(periodName!) : "Unknown period passed")
  }
  
  func fetch() async {
    self.days = .error(.loading)
    
    days = await Requests().fetchSchedules(
      from: from,
      to: to,
      group: settings.group
    )
  }
}


struct Schedules_Previews: PreviewProvider {
  static var previews: some View {
    Schedules(from: .constant(.now), to: .constant(.now))
      .environmentObject(SettingsModel())
  }
}
