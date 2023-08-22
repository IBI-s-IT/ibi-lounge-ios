//
//  WeekHeaderView.swift
//  InfiniteWeekView
//
//  Created by Philipp Knoblauch on 13.05.23.
//

import SwiftUI

struct WeekHeaderView: View {
  @EnvironmentObject var weekStore: WeekStore
  @State var showDatePicker: Bool = false
  @State var showOptions: Bool = false
  
  var body: some View {
    HStack {
      DatePicker("Select Date", selection: $weekStore.selectedDate, displayedComponents: .date)
        .labelsHidden()
      Spacer()
      Button {
        withAnimation {
          weekStore.selectToday()
        }
      } label: {
        Text("main.today")
      }
      .buttonStyle(.bordered)
      .foregroundColor(.accentColor)
#if os(iOS)
      .buttonBorderShape(.capsule)
#endif
      Button {
        withAnimation {
          showOptions = true
        }
      } label: {
        Image(systemName: "gearshape")
      }
      .popover(isPresented: $showOptions, content: {
        Toggle(isOn: $weekStore.isWholeWeek, label: {
          Text("Вся неделя")
        })
        .padding()
        .presentationCompactAdaptation((.popover))
      })
    }
  }
}

struct WeekHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    WeekHeaderView()
      .environmentObject(WeekStore())
  }
}
