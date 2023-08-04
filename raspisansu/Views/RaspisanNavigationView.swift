//
//  RaspisanNavigationView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 23.06.2023.
//

import SwiftUI

struct RaspisanNavigationView: View {
  @EnvironmentObject var schedules: SchedulesModel;
  
  var body: some View {
    NavigationView {
      List {
        Section {
          ForEach(1..<4) { rangeMode in
            NavigationLink {
              RaspisanView(rangeMode: rangeMode)
            } label: {
              Text(rangeMode == 0 ? "main.this_week" : rangeMode == 1 ? "main.next_week": rangeMode == 2 ? "main.this_month" : "main.custom_range")
            }
          }
        }
        Section("main.this_week") {
          SchedulesView(rangeMode: 0)
        }
      }
      .refreshable {
        Task.init {
          await schedules.fetchDays()
        }
      }
      
      .navigationTitle("main.title")
      #if os(macOS)
      .listStyle(.sidebar)
      #endif
    }
  }
}

#Preview {
  RaspisanNavigationView()
    .environmentObject(SchedulesModel())
}
