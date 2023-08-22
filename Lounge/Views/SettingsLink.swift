//
//  SettingsLink.swift
//  LoungeApp
//
//  Created by gbowsky on 22.08.2023.
//

import SwiftUI

#if os(macOS)
@available(macOS 13, *)
struct SettingsLink: View {
  var body: some View {
    Button {
      NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    } label: {
      Label("settings.title", systemImage: "gearshape")
    }
  }
}

struct SettingsLink_Previews: PreviewProvider {
  static var previews: some View {
    SettingsLink()
  }
}
#endif
