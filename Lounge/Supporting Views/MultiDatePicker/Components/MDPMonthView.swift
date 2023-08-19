//
//  MonthView.swift
//  MultiDatePickerApp
//
//  Created by Peter Ent on 11/2/20.
//

import SwiftUI

/**
 * MDPMonthView is really the crux of the control. This displays everything and handles the interactions
 * and selections. MulitDatePicker is the public interface that sets up the model and this view.
 */
struct MDPMonthView: View {
  @EnvironmentObject var monthDataModel: MDPModel
  
  @State private var showMonthYearPicker = false
  @State private var testDate = Date()
  
  private func showPrevMonth() {
    withAnimation {
      monthDataModel.decrMonth()
      showMonthYearPicker = false
    }
  }
  
  private func showNextMonth() {
    withAnimation {
      monthDataModel.incrMonth()
      showMonthYearPicker = false
    }
  }
  
  var body: some View {
    VStack {
      HStack {
        MDPMonthYearPickerButton(isPresented: self.$showMonthYearPicker)
        Spacer()
        Button( action: {showPrevMonth()} ) {
          Image(systemName: "chevron.left").font(.title2)
        }.padding()
        Button( action: {showNextMonth()} ) {
          Image(systemName: "chevron.right").font(.title2)
        }.padding()
      }
      .padding(.leading, 10)
      .buttonStyle(.plain)
      .foregroundColor(.accentColor)
      
      GeometryReader { reader in
        if showMonthYearPicker {
          MDPMonthYearPicker(date: monthDataModel.controlDate) { (month, year) in
            self.monthDataModel.show(month: month, year: year)
          }
        }
        else {
          MDPContentView()
        }
      }
    }
    .frame(minWidth: 278, maxWidth: .infinity, minHeight: 300)
    .padding(5)
  }
}

struct MonthView_Previews: PreviewProvider {
  static var previews: some View {
    MDPMonthView()
      .environmentObject(MDPModel())
  }
}
