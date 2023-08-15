//
//  OnboardingSheet.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 12.08.2023.
//

import SwiftUI

struct OnboardingSheet: View {
  @State var stage: Int = 0;
  @Environment(\.dismiss) private var dismiss;
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(alignment: .leading) {
#if os(iOS)
        Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
          .resizable(resizingMode: .stretch)
          .frame(width: 84, height: 84)
          .cornerRadius(22)
          .padding(.top)
#endif
        Text("onboarding.welcome1")
        Text("IBI Lounge")
          .fontDesign(.rounded)
          .foregroundStyle(.green.gradient)
      }
      .background(.background)
      .padding()
      .font(.largeTitle)
      .fontWeight(.bold)
      Group {
        if stage == 0 {
          ScrollView {
            VStack(alignment: .leading, spacing: 20) {
              OnboardingItem(systemName: "graduationcap.fill", symbolColor: Color.cyan.gradient, title: "onboarding.item1.title", subtitle: "onboarding.item1.subtitle")
              OnboardingItem(systemName: "house.fill", symbolColor: Color.blue.gradient, title: "onboarding.item2.title", subtitle: "onboarding.item2.subtitle")
              OnboardingItem(systemName: "list.bullet.rectangle.fill", symbolColor: Color.purple.gradient, title: "onboarding.item3.title", subtitle: "onboarding.item3.subtitle")
            }
          }
        } else {
          List {
            Group {
              SchedulesSettings()
              Text("onboarding.schedules.footnote")
                .listRowSeparator(.hidden)
                .font(.footnote)
              GradesSettings()
              Text("onboarding.grades.footnote")
                .listRowSeparator(.hidden)
                .font(.footnote)
            }
            .listRowInsets(EdgeInsets())
          }
#if os(iOS)
          .listStyle(.plain)
#endif
        }
      }
      .padding(.horizontal)
      .safeAreaInset(edge: .bottom) {
        VStack(spacing: 10) {
          Button {
            if stage == 0 {
              withAnimation(.easeInOut) {
                stage += 1
              }
            } else {
              dismiss()
            }
            
          } label: {
            Text(stage == 0 ? "onboarding.proceed1" : "onboarding.proceed2")
              .padding(.vertical, 8.0)
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.borderedProminent)
          .padding([.top, .leading, .trailing])
          
          Text(stage == 0 ? "onboarding.disclaimer1" : "onboarding.disclaimer2")
            .font(.footnote)
            .padding([.leading, .bottom, .trailing])
            .foregroundStyle(.secondary)
        }
        .background(.background)
      }
      .interactiveDismissDisabled(true)
    }
  }
}


#Preview {
  NavigationStack {}
    .sheet(isPresented: .constant(true), content: {
      OnboardingSheet()
    })
    .environmentObject(SettingsModel())
}
