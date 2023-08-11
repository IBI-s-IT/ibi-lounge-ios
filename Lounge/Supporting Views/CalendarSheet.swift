//
//  CalendarSheet.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 10.08.2023.
//

import SwiftUI

struct CalendarSheet: View {
  @Environment(\.dismiss) private var dismiss
  var range: Binding<ClosedRange<Date>?>
  
  var body: some View {
    NavigationStack {
      MultiDatePicker(dateRange: range)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .toolbar {
          ToolbarItem(placement: .automatic) {
            Button("main.done") {
              dismiss()
            }
            .disabled(range.wrappedValue == nil)
          }
        }
        .navigationTitle("main.custom_range")
    }
    .presentationDetents([.height(380)])
    .interactiveDismissDisabled(range.wrappedValue == nil)
  }
}
