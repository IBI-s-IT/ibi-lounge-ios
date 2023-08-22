//
//  CalendarView.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 22.08.2023.
//

import SwiftUI

enum SchedulesPeriods: String, Identifiable, CaseIterable {
  var id: Self {
    return self
  }
  
  case this_week
  case next_week
  case this_month
  case next_month
  case custom_range
  
  var title: String {
    return "main.\(self.rawValue)"
  }
}

func presetPeriod(period: SchedulesPeriods) -> (Date, Date) {
  switch period {
  case .this_week:
    return (Date().startOfWeek, Date().endOfWeek)
  case .next_week:
    return (Date().startOfNextWeek, Date().endOfNextWeek)
  case .this_month:
    return (Date().startOfMonth(), Date().endOfMonth())
  case .next_month:
    return (Date().startOfNextMonth(), Date().endOfNextMonth())
  case .custom_range:
    return (.now, .now)
  }
}

struct PeriodSelector: View {
  @Binding var schedulePeriod: SchedulesPeriods?
  @Binding var to: Date
  @Binding var from: Date

  var body: some View {
    List(selection: $schedulePeriod) {
      ForEach(SchedulesPeriods.allCases) { period in
        Text(LocalizedStringKey(String("main.\(period.rawValue)")))
          .frame(maxWidth: .infinity, alignment: .leading)
          .multilineTextAlignment(.leading)
          .contentShape(Rectangle())
          .onTapGesture {
            withAnimation {
              schedulePeriod = period
            }
          }
      }
      if schedulePeriod == .custom_range {
        Section("main.custom_range") {
          DatePicker(selection: $from, displayedComponents: .date) {
            Text("main.from")
          }
          DatePicker(selection: $to, displayedComponents: .date) {
            Text("main.to")
          }
        }
      }
    }
  }
}

