//
//  WeekView.swift
//  InfiniteWeekView
//
//  Created by Philipp Knoblauch on 13.05.23.
//

import SwiftUI

struct WeekView: View {
  @EnvironmentObject var weekStore: WeekStore
  
  var week: Week
  
  var body: some View {
    HStack {
      ForEach(0..<7) { i in
        if i == 0 {
          Spacer()
            .frame(width: 16)
        }
        VStack {
          Text(week.dates[i].toString(format: "EEE").lowercased())
            .font(.caption2)
          Text(week.dates[i].toString(format: "d"))
            .frame(maxWidth: .infinity)
        }
        .frame(width: 40, height: 40)
        .background(week.dates[i] == week.referenceDate ? .blue : .cardBackground)
        .foregroundColor(week.dates[i] == week.referenceDate ? .white : .primary)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.06), radius: 4)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        .onTapGesture {
          withAnimation {
            weekStore.selectedDate = week.dates[i]
          }
        }
        if i != 6 {
          Spacer()
        } else {
          Spacer()
            .frame(width: 16)
        }
      }
    }
  }
}

struct WeekView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      List {
        Text("Hello")
      }
      .safeAreaInset(edge: .top) {
        WeekView(week: .init(index: 1, dates:
                              [
                                Date().yesterday.yesterday.yesterday,
                                Date().yesterday.yesterday,
                                Date().yesterday,
                                Date(),
                                Date().tomorrow,
                                Date().tomorrow.tomorrow,
                                Date().tomorrow.tomorrow.tomorrow
                              ],
                             referenceDate: Date()))
      }
    }
    .environmentObject(WeekStore())
  }
}
