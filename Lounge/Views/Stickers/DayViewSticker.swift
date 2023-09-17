//
//  Day.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 18.06.2023.
//

import SwiftUI

struct DayViewSticker: View {
  var day: Day;
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        #if os(iOS)
        Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
          .resizable(resizingMode: .stretch)
          .frame(width: 16, height: 16)
          .cornerRadius(2)
        #elseif os(macOS)
        Image(nsImage: NSImage(imageLiteralResourceName: "AppIcon"))
          .resizable(resizingMode: .stretch)
          .frame(width: 16, height: 16)
          .cornerRadius(2)
        #endif
        Text("IBI Lounge")
          .fontDesign(.rounded)
          .fontWeight(.bold)
          .foregroundStyle(.green.gradient)
        Spacer()
        Text(day.date.formatted(date: .abbreviated, time: .omitted))
      }
      ForEach(day.lessons) { lesson in
        LessonView(lesson: lesson)
      }
    }
    .padding()
    .background(.black)
    .foregroundColor(.white)
    .cornerRadius(10)
    .frame(minWidth: 384)
  }
}

struct DayViewSticker_Previews: PreviewProvider {
  static var previews: some View {
    DayViewSticker(
      day: Day(date: Date(), lessons: [
        Lesson(
          text: "Операц.сист",
          time_start: Date(timeIntervalSince1970: 1682316000),
          time_end: Date(timeIntervalSince1970: 1682321400),
          additional:
            AdditionalLesson(
              is_online: true,
              type: LessonType.exam,
              teacher_name: "Андреев И.В."
            )
        ),
        Lesson(
          text: "Операц.сист",
          time_start: Date(timeIntervalSince1970: 1682321400),
          time_end: Date(timeIntervalSince1970: 1682321400),
          additional:
            AdditionalLesson(
              is_online: true,
              type: LessonType.exam,
              teacher_name: "Андреев И.В."
            )
        ),
        Lesson(
          text: "Операц.сист",
          time_start: Date(timeIntervalSince1970: 1682322800),
          time_end: Date(timeIntervalSince1970: 1682341401),
          additional:
            AdditionalLesson(
              is_online: true,
              type: LessonType.exam,
              teacher_name: "Андреев И.В."
            )
        ),
        Lesson(
          text: "Операц.сист",
          time_start: Date(timeIntervalSince1970: 1682322800),
          time_end: Date(timeIntervalSince1970: 1682341401),
          additional:
            AdditionalLesson(
              is_online: true,
              type: LessonType.exam,
              teacher_name: "Андреев И.В."
            )
        ),
      ])
    )
  }
}
