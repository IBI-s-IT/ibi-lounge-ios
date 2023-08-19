//
//  ErrorScreen.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 23.07.2023.
//

import SwiftUI

struct ErrorScreen: View {
  var icon: String;
  var title: String;
  var description: String;
  var code: String;
  var action: (() -> Void)?
  
  var body: some View {
    VStack(alignment: .center) {
      Image(systemName: icon)
        .resizable(resizingMode: .stretch)
        .frame(width: 30.0, height: 30.0)
      Text(LocalizedStringKey(title))
        .font(.title)
        .multilineTextAlignment(.center)
      Text(LocalizedStringKey(description))
        .font(.headline)
        .multilineTextAlignment(.center)
      Text("error.code \(code)")
        .font(.subheadline)
        .foregroundColor(Color.gray)
        .multilineTextAlignment(.center)
        .padding(.vertical, 4.0)
      if action != nil {
        Button("error.try_again") {
          action?()
        }
        .buttonStyle(BorderlessButtonStyle())
      }
    }
    .frame(
      minWidth: 0,
      maxWidth: .infinity,
      minHeight: 0,
      maxHeight: .infinity,
      alignment: .center
    )
    .padding(.vertical)
  }
}

struct ErrorScreen_Previews: PreviewProvider {
  static var previews: some View {
    ErrorScreen(icon: "gear", title: "title", description: "description", code: "123") {
      print("try")
    }
  }
}
