//
//  Lesson.swift
//  DailyWidget
//
//  Created by g.gorbovskoy on 06.08.2023.
//

import SwiftUI

struct WidgetLesson: View {
  var lesson: Lesson;
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 0) {
        Text(lesson.time_start.formatted(date: .omitted, time: .shortened))
        if lesson.additional?.location != nil {
          if lesson.additional?.is_online != nil {
            if lesson.additional!.is_online! {
              Text(" · ")
              Text("schedules.is_online")
            } else {
              Text(" · ")
              Text("schedules.place \(lesson.additional!.location!)")
            }
          } else {
            Text(" · ")
            Text("schedules.place \(lesson.additional!.location!)")
          }
        }
      }
      .font(.caption2.weight(.semibold))
      .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
      Text(lesson.text)
        .lineLimit(1)
        .font(.callout)
      HStack(spacing: 0)  {
        if lesson.additional?.type != nil {
          Text(LocalizedStringKey(String("schedules.\(lesson.additional!.type!.rawValue)")))
        }
      }
      .font(.caption2)
      .lineLimit(1)
    }
  }
}

#Preview {
  WidgetLesson(lesson: Lesson(
    text: "Операц.сист",
    time_start: Date(),
    time_end: Date(),
    additional:
      AdditionalLesson(
        is_online: false,
        type: LessonType.subject_report,
        teacher_name: "Андреев И.В."
      )
  ))
}
