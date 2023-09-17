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
    VStack(alignment: .leading, spacing: 0) {
      Text(getDateFormatted(day: day))
        .font(.callout)
        .foregroundStyle(day.date.isInSameDay(as: .now) ? .white : .secondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(day.date.isInSameDay(as: .now) ? Color("AccentColor") : Color("AccentColor").opacity(0))
        .cornerRadius(10)
        .padding(.bottom, 8)
      VStack {
        ForEach(day.lessons) { lesson in
          LessonView(lesson: lesson)
          if day.lessons.last?.id != lesson.id {
            Divider()
          }
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(.cardBackground)
      .cornerRadius(10)
      .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 4)
      .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
    }
    .padding()
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
      color: Color("AccentColor").opacity(lightIsOn ?? false ? 0.42 : 0),
      radius: lightIsOn ?? false ? 12 : 0
    )
    .id(day.date)
  }
}

struct DayView_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView() {
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
