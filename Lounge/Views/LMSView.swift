//
//  LMSView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 23.06.2023.
//

import SwiftUI
import WebKit

#if os(iOS)
struct WebView: UIViewRepresentable {
  typealias UIViewType = WKWebView
  
  let webView: WKWebView
  
  func makeUIView(context: Context) -> WKWebView {
    return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) { }
}
#endif

#if os(macOS)
struct WebView: NSViewRepresentable {
  typealias NSViewType = WKWebView
  
  let webView: WKWebView
  
  func makeNSView(context: Context) -> WKWebView {
    return webView
  }
  
  func updateNSView(_ nsView: WKWebView, context: Context) { }
}
#endif

struct LMSView: View {
  @StateObject var model = WebViewModel()
  
  var body: some View {
    WebView(webView: model.webView)
      .toolbar(content: {
        ToolbarItem(placement: .navigation) {
          Button(action: {
            model.goBack()
          }, label: {
            Image(systemName: "chevron.left")
          })
          .disabled(!model.canGoBack)
        }
        ToolbarItem(placement: .navigation) {
          Button(action: {
            model.goForward()
          }, label: {
            Image(systemName: "chevron.right")
          })
          .disabled(!model.canGoForward)
        }
        ToolbarItem(placement: .navigation) {
          Button(action: {
            model.reload()
          }, label: {
            Image(systemName: "arrow.clockwise")
          })
        }
        #if os(macOS)
        ToolbarItem(placement: .primaryAction) {
          ShareLink(item: model.url)
        }
        #endif
      })
      .navigationTitle(model.title ?? "lms.title")
#if os(iOS)
      .navigationDocument(model.url)
      .navigationBarTitleDisplayMode(.inline)
#endif
  }
}


struct LMSView_Previews: PreviewProvider {
  static var previews: some View {
    LMSView()
  }
}
