//
//  WebViewModel.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 05.08.2023.
//

import Foundation
import WebKit

class WebViewModel: ObservableObject {
  let webView: WKWebView
  let url: URL
  
  init() {
    webView = WKWebView(frame: .zero)
    webView.allowsLinkPreview = true;
    webView.allowsBackForwardNavigationGestures = true;
    url = URL(string: "https://lms.ibispb.ru")!
    
    loadUrl()
    setupBindings()
  }
  
  func loadUrl() {
    webView.load(URLRequest(url: url))
  }
  
  func goForward() {
    webView.goForward()
  }
  
  func goBack() {
    webView.goBack()
  }
  
  func reload() {
    webView.reload()
  }
  
  @Published var canGoBack: Bool = false
  @Published var canGoForward: Bool = false
  @Published var title: String? = ""
  
  private func setupBindings() {
    webView.publisher(for: \.canGoBack)
      .assign(to: &$canGoBack)

    
    webView.publisher(for: \.canGoForward)
      .assign(to: &$canGoForward)
    
    webView.publisher(for: \.title)
      .assign(to: &$title)
  }
}
