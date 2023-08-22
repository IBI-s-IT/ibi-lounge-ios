//
//  MaterialsNavigator.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 22.08.2023.
//

import SwiftUI

enum MaterialsLinks: String, Identifiable, CaseIterable {
  case lms
  case news
  case employees
  case contacts
  
  var id: Self {
    return self
  }
  
  var title: String {
    switch self {
    case .lms:
      "materials.lms"
    case .news:
      "materials.news"
    case .employees:
      "materials.employees"
    case .contacts:
      "materials.contacts"
    }
  }
  
  var icon: String {
    switch self {
    case .lms:
      return "checklist"
    case .news:
      return "newspaper"
    case .employees:
      return "person.circle"
    case .contacts:
      return "person.text.rectangle"
    }
  }
  
  var url: String {
    switch self {
    case .lms:
      return "https://lms.ibispb.ru"
    case .news:
      return "https://ibispb.ru/news/"
    case .employees:
      return "https://ibispb.ru/sveden/employees/"
    case .contacts:
      return "https://ibispb.ru/contacts/"
    }
  }
}

struct MaterialsNavigator: View {
  @Binding var openedLink: MaterialsLinks?
  @EnvironmentObject var webView: WebViewModel
  
  var body: some View {
    List(MaterialsLinks.allCases, selection: $openedLink) { link in
      Label(LocalizedStringKey(link.title), systemImage: link.icon)
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
        .contentShape(Rectangle())
        .onTapGesture {
          openedLink = link
          webView.loadUrl(destUrl: URL(string: link.url)!)
        }
        .navigationTitle("materials.title")
    }
  }
}

struct MaterialsNavigator_Previews: PreviewProvider {
  static var previews: some View {
    MaterialsNavigator(openedLink: .constant(.lms))
  }
}
