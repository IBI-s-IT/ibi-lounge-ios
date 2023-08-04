//
//  SchedulesView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 29.07.2023.
//

import SwiftUI

struct SchedulesView: View {
  var rangeMode: Int;
  @EnvironmentObject var schedules: SchedulesModel;
  
  var body: some View {
    VStack {
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
      Task.init {
        await schedules.fetchDays()
      }
      schedules.rangeMode = rangeMode;
    })
  }
}

#Preview {
  SchedulesView(rangeMode: 3)
}
