//
//  CalendarSheet.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 10.08.2023.
//

import SwiftUI

struct CalendarSheet: View {
  var range: Binding<ClosedRange<Date>?>
  var isPresented: Binding<Bool>;
  
  func hideSheet() {
    withAnimation {
      isPresented.wrappedValue = false;
    }
  }
  
  var body: some View {
    if isPresented.wrappedValue {
      GeometryReader { geometry in
        ZStack {
          Rectangle()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .opacity(0.3)
            .layoutPriority(-1)
            .onTapGesture {
              if range.wrappedValue != nil {
                hideSheet()
              }
            }
#if os(iOS)
          NavigationStack {
            MultiDatePicker(dateRange: range)
              .padding(.top, 10)
              .padding(.bottom, 10)
              .toolbar {
                ToolbarItem(placement: .automatic) {
                  Button("main.done") {
                    hideSheet()
                  }
                  .disabled(range.wrappedValue == nil)
                }
              }
              .navigationTitle("main.custom_range")
            
              .navigationBarTitleDisplayMode(.inline)
          }
          .frame(maxWidth: 350, maxHeight: 380)
          .cornerRadius(10)
#else
          VStack(spacing: 0) {
            MultiDatePicker(dateRange: range)
            Divider()
            HStack() {
              Spacer()
              Button("main.done") {
                hideSheet()
              }
              .disabled(range.wrappedValue == nil)
              .buttonStyle(.borderedProminent)
              .padding()
            }
          }
          .background(.cardBackground)
          .cornerRadius(10)
          .frame(maxWidth: 350, maxHeight: 300)
#endif
        }
        .ignoresSafeArea()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      }
      .ignoresSafeArea()
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
  }
}
