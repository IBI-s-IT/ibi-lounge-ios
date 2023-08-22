//
//  DeskNavigator.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 21.08.2023.
//

import SwiftUI

enum DeskTabs: String, CaseIterable, Identifiable {
  case main
  case grades
  case lms
#if os(iOS)
  case settings
#endif
  
  var id: Self {
    return self
  }
  
  var title: String {
    switch self {
    case .main:
      return "main.title"
    case .grades:
      return "grades.title"
    case .lms:
      return "materials.title"
#if os(iOS)
    case .settings:
      return "settings.title"
#endif
    }
  }
  
  var icon: String {
    switch self {
    case .main:
      return "calendar"
    case .grades:
      return "graduationcap"
    case .lms:
      return "newspaper"
#if os(iOS)
    case .settings:
      return "gearshape"
#endif
    }
  }
}

struct DeskNavigator: View {
  @State var selectedTab: DeskTabs? = .main
  @State var schedulePeriod: SchedulesPeriods? = .this_week
  @State var settingsSection: SettingsSections? = .schedules
  @State var openedLink: MaterialsLinks? = .lms
  @State var from: Date = .now
  @State var to: Date = .now
  
  var contents: some View {
    Group {
      switch selectedTab {
      case .main, nil:
        PeriodSelector(schedulePeriod: $schedulePeriod, to: $to, from: $from)
          .navigationTitle("main.title")
          .onChange(of: schedulePeriod ?? .this_week) { period in
            if period != .custom_range {
              let nextPeriod = presetPeriod(period: period)
              from = nextPeriod.0
              to = nextPeriod.1
            }
          }
      case .grades:
        List {
          GradesSettings()
            .navigationTitle("grades.data")
        }
      case .lms:
        MaterialsNavigator(openedLink: $openedLink)
#if os(iOS)
      case .settings:
        SettingsSelector(settingsSection: $settingsSection)
#endif
      }
    }
  }
  
  var body: some View {
    NavigationSplitView() {
      List(DeskTabs.allCases, selection: $selectedTab) { tab in
        Label(LocalizedStringKey(tab.title), systemImage: tab.icon)
      }
      #if os(macOS)
      .toolbar {
        ToolbarItem(placement: .automatic) {
          SettingsLink()
        }
      }
      .navigationSplitViewColumnWidth(178)
      #endif
      .navigationTitle("main.name")
    } content: {
      contents
#if os(iOS)
        .navigationSplitViewColumnWidth(278)
#elseif os(macOS)
        .navigationSplitViewColumnWidth(200)
#endif
    } detail: {
      Group {
        switch selectedTab {
        case .main, nil:
          Schedules(from: $from, to: $to, periodName: schedulePeriod?.title ?? "main.title")
        case .grades:
          GradesView()
        case .lms:
          LMSView()
#if os(iOS)
        case .settings:
          List {
            switch settingsSection {
            case .schedules, nil:
              SchedulesSettings()
                .navigationTitle("settings.section.schedule")
            case .grades:
              GradesSettings()
                .navigationTitle("grades.data")
            }
          }
#endif
        }
      }
      .navigationSplitViewColumnWidth(min: 270, ideal: 500)
    }
    .onAppear(perform: {
      let nextPeriod = presetPeriod(period: schedulePeriod ?? .this_week)
      from = nextPeriod.0
      to = nextPeriod.1
    })
  }
}

struct DeskNavigator_Previews: PreviewProvider {
  static var previews: some View {
    DeskNavigator()
      .environment(\.locale, .init(identifier: "ru"))
      .environmentObject(SettingsModel())
      .environmentObject(WeekStore())
      .frame(minWidth: 800)
  }
}
