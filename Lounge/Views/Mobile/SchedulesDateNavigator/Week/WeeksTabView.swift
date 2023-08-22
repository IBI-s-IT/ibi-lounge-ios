//
//  WeeksTabView.swift
//  InfiniteWeekView
//
//  Created by Philipp Knoblauch on 13.05.23.
//

import SwiftUI

struct WeeksTabView<Content: View>: View {
  @EnvironmentObject var weekStore: WeekStore
  
  @State private var activeTab: Int = 1
  @State private var direction: TimeDirection = .unknown
  @State private var position = CGSize.zero
  @GestureState private var dragOffset = CGSize.zero
  
  let content: (_ week: Week) -> Content
  
  init(@ViewBuilder content: @escaping (_ week: Week) -> Content) {
    self.content = content
  }
  
  var body: some View {
    TabView(selection: $activeTab) {
      content(weekStore.weeks[0])
        .frame(maxWidth: .infinity)
        .tag(0)
      
      content(weekStore.weeks[1])
        .frame(maxWidth: .infinity)
        .tag(1)
        .onDisappear() {
          guard direction != .unknown else { return }
          weekStore.update(to: direction)
          direction = .unknown
          activeTab = 1
        }
      
      content(weekStore.weeks[2])
        .frame(maxWidth: .infinity)
        .tag(2)
    }
    #if os(iOS)
    .tabViewStyle(.page(indexDisplayMode: .never))
    #endif
    .frame(height: 50)
    .onChange(of: activeTab) { value in
      if value == 0 {
        direction = .past
      } else if value == 2 {
        direction = .future
      }
    }
  }
}

struct WeeksTabView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        Text("Hello")
      }
      .safeAreaInset(edge: .top, content: {
        WeeksTabView() { week in
          WeekView(week: week)
        }
      })
      .navigationTitle("Test")
    }
    .environmentObject(WeekStore())
  }
}
