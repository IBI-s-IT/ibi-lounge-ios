//
//  ContentView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 17.06.2023.
//

import SwiftUI

struct ContentView: View {
  @State var isPresented: Bool = false;
  
  var body: some View {
#if os(macOS)
    NavigationView {
      List {
        NavigationLink {
          RaspisanNavigationView()
        } label: {
          Label("main.title", systemImage: "calendar")
        }
        NavigationLink {
          LMSView()
        } label: {
          Label("lms.title", systemImage: "list.bullet.below.rectangle")
        }
        NavigationLink {
          GradesView()
        } label: {
          Label("grades.title", systemImage: "graduationcap")
        }
      }
      .listStyle(.sidebar)
      .toolbar {
        SettingsLink()
      }
    }
#else
    TabView {
      RaspisanNavigationView()
        .tabItem {
          Label("main.title", systemImage: "calendar")
        }
      LMSView()
        .tabItem {
          Label("lms.title", systemImage: "list.bullet.below.rectangle")
        }
      GradesView()
        .tabItem {
          Label("grades.title", systemImage: "graduationcap")
        }
      NavigationStack { SettingsView() }
        .tabItem {
          Label("settings.title", systemImage: "gearshape")
        }
    }
#endif
  }
}

#Preview {
  ContentView()
    .environment(\.locale, .init(identifier: "ru"))
    .environmentObject(SchedulesModel())
    .environmentObject(GroupsModel())
    .environmentObject(GradesModel())
}
