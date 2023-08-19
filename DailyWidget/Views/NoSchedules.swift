//
//  NoSchedules.swift
//  DailyWidget
//
//  Created by g.gorbovskoy on 06.08.2023.
//

import SwiftUI

struct NoSchedules: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text("🍕")
        .font(.title)
      Text("widget.no_schedules")
        .font(.system(.title, design: .serif))
      Text("widget.no_schedules.desc")
        .font(.system(.callout, design: .serif))
    }
  }
}

struct NoSchedules_Previews: PreviewProvider {
    static var previews: some View {
      NoSchedules()
    }
}
