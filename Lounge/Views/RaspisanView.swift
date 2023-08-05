//
//  RaspisanView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 21.06.2023.
//

import SwiftUI

struct RaspisanView: View {
  var rangeMode: Int;
  @EnvironmentObject var schedules: SchedulesModel;
  
  var body: some View {
    List {
      if (rangeMode == 3) {
        Section {
          DatePicker("main.from", selection: $schedules.dateFrom, in: ...schedules.dateTo, displayedComponents: .date)
          DatePicker("main.to", selection: $schedules.dateTo, in: schedules.dateFrom..., displayedComponents: .date)
        }
        .datePickerStyle(.compact)
      }

      if schedules.raspState == .loading {
        ProgressView()
      } else if schedules.daysError != nil {
        TransientStatusNew(error: schedules.daysError!)  {
          Task.init {
            await schedules.fetchDays()
          }
        }
      } else {
        if let results = schedules.days {
          if results.response != nil {
            ForEach(results.response!, id: \.self.date) { day in
              DayView(
                day: day
              )
            }
          }
        }
      }
    }
    .refreshable {
      await schedules.fetchDays()
    }
    .onAppear(perform: {
      schedules.rangeMode = rangeMode;
      Task.init {
        await schedules.fetchDays();
      }
    })
    .navigationTitle(rangeMode == 0 ? "main.this_week" : rangeMode == 1 ? "main.next_week" : rangeMode == 2 ? "main.this_month" : "main.custom_range")
  }
}

#Preview {
  RaspisanView(rangeMode: 1)
    .environment(\.locale, .init(identifier: "en"))
    .environmentObject(SchedulesModel())
    .frame(minWidth: 400, minHeight: 300)
}
