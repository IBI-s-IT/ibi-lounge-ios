//
//  MultiDatePicker.swift
//  MultiDatePickerApp
//
//  Created by Peter Ent on 11/3/20.
//

import SwiftUI

/**
 * init(dateRange: Binding<ClosedRange<Date>?>, [,options])
 *      Selects a date range. Tapping on a date marks it as the first date, tapping a second date
 *      completes the range. Tapping a date again resets the range. The binding will be nil unless
 *      two dates are selected, completeing the range.
 *
 * optional parameters to init() functions are:
 *  - includeDays: .allDays, .weekdaysOnly, .weekendsOnly
 *      Days not selectable are shown in gray and not selected.
 *  - minDate: Date? = nil
 *      Days before minDate are not selectable.
 *  - maxDate: Date? = nil
 *      Days after maxDate are not selectable.
 */
struct MultiDatePicker: View {
  
  // the type of picker, based on which init() function is used.
  enum PickerType {
    case dateRange
  }
  
  // lets all or some dates be elligible for selection.
  enum DateSelectionChoices {
    case allDays
    case weekendsOnly
    case weekdaysOnly
  }
  
  @StateObject var monthModel: MDPModel
  
  init(dateRange: Binding<ClosedRange<Date>?>,
       includeDays: DateSelectionChoices = .allDays,
       minDate: Date? = nil,
       maxDate: Date? = nil
  ) {
    _monthModel = StateObject(wrappedValue: MDPModel(dateRange: dateRange, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
  }
  
  var body: some View {
    MDPMonthView()
      .environmentObject(monthModel)
  }
}

struct MultiDatePicker_Previews: PreviewProvider {
  @State static var oneDay = Date()
  @State static var manyDates = [Date]()
  @State static var dateRange: ClosedRange<Date>? = nil
  
  static var previews: some View {
    VStack {
      MultiDatePicker(dateRange: $dateRange)
    }
  }
}
