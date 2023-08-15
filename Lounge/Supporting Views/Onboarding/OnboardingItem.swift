//
//  OnboardingItem.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 13.08.2023.
//

import SwiftUI

struct OnboardingItem: View {
  var systemName: String;
  var symbolColor: AnyGradient;
  var title: String;
  var subtitle: String;
  
  var body: some View {
    HStack() {
      Image(systemName: systemName)
        .font(.system(size: 32.0))
        .frame(width: 48)
        .imageScale(.small)
        .foregroundStyle(symbolColor)
      VStack(alignment: .leading) {
        Text(LocalizedStringKey(title))
          .font(.headline)
        Text(LocalizedStringKey(subtitle))
          .font(.subheadline)
      }
      Spacer()
    }
    .padding(.trailing)
  }
}

#Preview {
  ScrollView {
    VStack(alignment: .leading, spacing: 10) {
      OnboardingItem(systemName: "graduationcap.fill", symbolColor: Color.cyan.gradient, title: "Всё в одном для МБИ", subtitle: "Здесь есть и ЕЭОС и расписание и ваши оценки")
      OnboardingItem(systemName: "house.fill", symbolColor: Color.blue.gradient, title: "Виджет расписания", subtitle: "Отобразит непройденные пары на сегодня и на завтра на экране Домой")
      OnboardingItem(systemName: "list.bullet.rectangle.fill", symbolColor: Color.purple.gradient, title: "Оценки", subtitle: "Быстрый доступ к оценкам из приложения")
    }
  }
}
