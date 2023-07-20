//
//  SegmentedControl.swift
//  SegmentedControlSwiftUI
//
//  Created by Rahul Sharma on 05/03/22.
//

import SwiftUI

struct SegmentedControl: View {
  
  var items: [String]
  
  @Binding var selectedIndex: Int
  
  @Namespace var namespace
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(items.indices, id: \.self) { index in
            Text(LocalizedStringKey(items[index]))
              .font(.title3)
              .fontWeight(.semibold)
              .padding(.horizontal, 12.0)
              .padding(.vertical, 6.0)
              .matchedGeometryEffect(
                id: index,
                in: namespace,
                isSource: true
              )
              .onTapGesture {
                withAnimation {
                  selectedIndex = index
                  proxy.scrollTo(index)
                }
              }
          }
        }
      }
      .clipShape(Capsule())
      .padding(4.0)
      .background {
        Capsule()
          .fill(Material.bar)
          .matchedGeometryEffect(
            id: selectedIndex,
            in: namespace,
            isSource: false
          )
      }
      .background {
        Capsule()
          .fill(Material.ultraThick)
      }
      .clipShape(Capsule())
    }
  }
  
}

struct SegmentedControl_Previews: PreviewProvider {
  static var previews: some View {
    SegmentedControl(
      items: ["Эта неделя", "След. неделя", "Этот месяц"],
      selectedIndex: .constant(0)
    )
  }
}
