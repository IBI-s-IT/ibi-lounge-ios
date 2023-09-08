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
  @EnvironmentObject var model: WebViewModel
  @State var showSheet = false
  @State var openedLink: MaterialsLinks? = .lms

  var body: some View {
    WebView(webView: model.webView)
      .toolbar {
#if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              showSheet = true
            } label: {
              Image(systemName: "list.bullet")
            }
            .sheet(isPresented: $showSheet) {
              NavigationStack {
                MaterialsNavigator(openedLink: $openedLink)
              }.onChange(of: openedLink) { _ in
                showSheet = false
              }
            }
          }
        }
#endif
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
        if (model.isLoading) {
          ToolbarItem(placement: .navigation) {
            ProgressView()
              .progressViewStyle(.circular)
              .controlSize(.small)
          }
        }
#if os(macOS)
        ToolbarItem(placement: .primaryAction) {
          ShareLink(item: model.url)
        }
#endif
      }
#if os(iOS)
      .navigationDocument(model.url)
      .navigationBarTitleDisplayMode(.inline)
#endif
      .navigationTitle(model.title ?? "lms.title")
  }
}


struct LMSView_Previews: PreviewProvider {
  static var previews: some View {
    LMSView()
  }
}
