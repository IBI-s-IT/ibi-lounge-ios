//
//  Schedules.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 06.08.2023.
//

import SwiftUI

struct Schedules: View {
  @State var from: Date = .now;
  @State var to: Date = .now;
  var periodName: String?;
  var isEmbedded: Bool = false;
  var isCustomPeriod: Bool = false;
  @EnvironmentObject var settings: SettingsModel;
  @State var days: DaysRequestResult = .error(.loading);
  
  var content: some View {
    switch days {
    case .response(let result):
      AnyView(
        ForEach(result.response!, id: \.self.date) { day in
          DayView(
            day: day
          )
        }
      )
    case .error(let error):
      AnyView(
        TransientStatusNew(error: error) {
          Task.init { await fetch() }
        }
      )
    }
  }
  
  var body: some View {
    if isEmbedded {
      VStack {
        content
      }
      .task {
        await fetch()
      }
    } else {
      List {
        if isCustomPeriod {
          Section {
            DatePicker("main.from", selection: $from, in: ...to, displayedComponents: .date)
              .onChange(of: from, perform: { _ in
                Task.init {
                  await self.fetch()
                }
              })
            DatePicker("main.to", selection: $to, in: from..., displayedComponents: .date)
              .onChange(of: from, perform: { _ in
                Task.init {
                  await self.fetch()
                }
              })
          }
          .datePickerStyle(.compact)
        }
        content
      }
      .task {
        await fetch()
      }
      .refreshable {
        await fetch()
      }
      .navigationTitle(periodName != nil ? LocalizedStringKey(periodName!) : "Unknown period passed")
    }
  }
  
  func fetch() async {
    days = await Requests().fetchSchedules(
      from: from,
      to: to,
      group: settings.group
    )
  }
}

#Preview {
  Schedules()
    .environmentObject(SettingsModel())
}
