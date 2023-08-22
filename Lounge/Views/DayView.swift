//
//  Day.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 18.06.2023.
//

import SwiftUI

func getDateFormatted(day: Day) -> String {
  let formatter = DateFormatter();
  formatter.setLocalizedDateFormatFromTemplate("dd.MM, EEEE");
  return formatter.string(from: day.date);
}

struct DayView: View {
  var day: Day;
  var lightIsOn: Bool?
  @Environment(\.locale) var locale
  @State var image: Image? = nil
  
  var snapshot: some View {
    DayViewSticker(day: day)
  }
  
  var body: some View {
    Section(getDateFormatted(day: day)) {
      ForEach(day.lessons) { lesson in
        LessonView(lesson: lesson)
      }
    }
    .onAppear {
      #if os(iOS)
      image = Image(uiImage: render(
        body: snapshot,
        locale: locale
      )!)
      #elseif os(macOS)
      image = Image(render(body: snapshot, locale: locale)!, scale: 3, label: Text("main.title"))
      #endif
    }
    .draggable(image!, preview: {
      DayViewSticker(day: day)
    })
    .shadow(
      color: .blue.opacity(lightIsOn ?? false ? 1 : 0),
      radius: lightIsOn ?? false ? 20 : 0
    )
    .id(day.date)
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
  }
}
