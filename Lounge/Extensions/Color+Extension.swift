//
//  Color+Extension.swift
//  LoungeApp
//
//  Created by gbowsky on 22.08.2023.
//

import SwiftUI

public extension Color {
#if os(macOS)
  static let background = Color(NSColor.windowBackgroundColor)
  static let secondaryBackground = Color(NSColor.underPageBackgroundColor)
  static let tertiaryBackground = Color(NSColor.controlBackgroundColor)
#else
  static let background = Color(UIColor.systemBackground)
  static let secondaryBackground = Color(UIColor.secondarySystemBackground)
  static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
#endif
}
