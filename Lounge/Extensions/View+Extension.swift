//
//  View+Extension.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 21.08.2023.
//

import Foundation
import SwiftUI
#if os(iOS)

extension DayView {
  @MainActor
  func render(body: some View, locale: Locale) -> UIImage?{
    let renderer = ImageRenderer(
      content: body
        .environment(\.locale, locale)
    )
    renderer.scale = 3
    
    let data = renderer.uiImage?.pngData()
    return UIImage(data: data!)
  }
}

#elseif os(macOS)
@MainActor
func render(body: some View, locale: Locale) -> CGImage?{
  let renderer = ImageRenderer(
    content: body
      .environment(\.locale, locale)
  )
  
  renderer.scale = 3

  return renderer.cgImage
}
#endif

