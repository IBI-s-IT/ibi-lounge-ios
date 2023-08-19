//
//  MonthContentView.swift
//  MultiDatePickerApp
//
//  Created by Peter Ent on 11/3/20.
//

import SwiftUI

/**
 * Displays the calendar of MDPDayOfMonth items using MDPDayView views.
 */
struct MDPContentView: View {
  @EnvironmentObject var monthDataModel: MDPModel
  @Environment(\.sizeCategory) var sizeCategory
  
  let cellSize: CGFloat = 30
  
  let columns = [
    GridItem(.adaptive(minimum: 30, maximum: .infinity), spacing: 5),
    GridItem(.adaptive(minimum: 30, maximum: .infinity), spacing: 5),
    GridItem(.adaptive(minimum: 30, maximum: .infinity), spacing: 5),
    GridItem(.adaptive(minimum: 30, maximum: .infinity), spacing: 5),
    GridItem(.adaptive(minimum: 30, maximum: .infinity), spacing: 5),
    GridItem(.adaptive(minimum: 30, maximum: .infinity), spacing: 5),
    GridItem(.adaptive(minimum: 30, maximum: .infinity), spacing: 5)
  ]
  
  var body: some View {
    LazyVGrid(columns: columns, spacing: 5) {
      
      // Sun, Mon, etc.
      ForEach(0..<monthDataModel.dayNames.count, id: \.self) { index in
        
        // If user has increased dynamic type size, truncate
        // day names to just first letter
        if sizeCategory > .large {
          Text(String(monthDataModel.dayNames[index].first!))
            .font(.caption)
            .foregroundColor(.gray)
        } else {
          Text(monthDataModel.dayNames[index].uppercased())
            .font(.caption)
            .foregroundColor(.gray)
        }
      }
      .padding(.bottom, 10)
      
      // The actual days of the month.
      ForEach(0..<monthDataModel.days.count, id: \.self) { index in
        if monthDataModel.days[index].day == 0 {
          Text("")
            .frame(minHeight: cellSize, maxHeight: cellSize)
        } else {
          MDPDayView(dayOfMonth: monthDataModel.days[index])
        }
      }
    }.padding(.bottom, 10)
  }
}

struct MonthContentView_Previews: PreviewProvider {
  static var previews: some View {
    MDPContentView()
  }
}
