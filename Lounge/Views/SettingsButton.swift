//
//  SettingsLink.swift
//  LoungeApp
//
//  Created by gbowsky on 22.08.2023.
//

import SwiftUI

#if os(macOS)
struct SettingsButton: View {
  var body: some View {
    if #available(macOS 14, *) {
      SettingsLink()
    } else {
      Button {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
      } label: {
        Label("settings.title", systemImage: "gearshape")
      }
    }
  }
}

struct SettingsLink_Previews: PreviewProvider {
  static var previews: some View {
    SettingsButton()
  }
}
#endif
