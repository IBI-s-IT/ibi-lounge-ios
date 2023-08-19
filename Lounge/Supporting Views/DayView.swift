//
//  Day.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 18.06.2023.
//

import SwiftUI

func getDateFromatted(day: Day) -> String {
  let formatter = DateFormatter();
  formatter.setLocalizedDateFormatFromTemplate("dd.MM, EEEE");
  return formatter.string(from: day.date);
}

struct DayView: View {
  var day: Day;
  
  var body: some View {
    Section(getDateFromatted(day: day)) {
      ForEach(day.lessons) { lesson in
        LessonView(lesson: lesson)
      }
    }
  }
}

struct DayView_Previews: PreviewProvider {
  static var previews: some View {
    List() {
      DayView(
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
          )
        ])
      )
    }
    .listStyle(.plain)
  }
}
