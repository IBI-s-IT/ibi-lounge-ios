//
//  LessonView.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 18.06.2023.
//

import SwiftUI

func getTimeStartFormatted(lesson: Lesson) -> String {
  let time_start = lesson.additional?.custom_time?.start ?? lesson.time_start;
  return time_start.formatted(date: .omitted, time: .shortened);
}

func getTimeEndFormatted(lesson: Lesson) -> String {
  let time_end = lesson.additional?.custom_time?.end ?? lesson.time_end;
  return time_end.formatted(date: .omitted, time: .shortened);
}

struct LessonView: View {
  @Environment(\.openURL) private var openURL
  var lesson: Lesson;
  
  var tap: some Gesture {
    TapGesture(count: 1)
      .onEnded {
        if lesson.additional?.url != nil {
          guard let url = URL(string: (lesson.additional?.url)!) else {
            return
          }
          
          openURL(url)
        }
      }
  }
  
  var body: some View {
    HStack() {
      VStack(alignment: .leading) {
        Text(getTimeStartFormatted(lesson: lesson) + " - " + getTimeEndFormatted(lesson: lesson))
          .padding(.bottom, 1)
        Text(lesson.text)
          .font(.title3)
          .fontWeight(.semibold)
        if lesson.additional?.teacher_name != nil {
          Text(lesson.additional!.teacher_name!)
            .font(.caption)
            .fontWeight(.semibold)
            .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
        }
      }
      Spacer()
      VStack(alignment: .trailing) {
        if lesson.additional?.type != nil {
          HStack {
            Text(LocalizedStringKey(String("schedules.\(lesson.additional!.type!.rawValue)")))
            Text(lesson.additional!.type!.emoji)
          }
          .padding(.bottom, 0.5)
        }
        if lesson.additional?.is_online ?? false {
          HStack {
            Text(LocalizedStringKey("schedules.is_online"))
            Text("🌎")
          }
        } else if lesson.additional?.location != nil {
          HStack {
            Text(lesson.additional!.location!)
            Text("🗺️")
          }
        } else {
          HStack {
            Text("schedules.unknown")
            Text("🤨")
          }
        }
      }
      .font(.footnote)
      .imageScale(.medium)
      .symbolRenderingMode(.multicolor)
      
      if lesson.additional?.url != nil {
        Image(systemName: "chevron.right")
          .foregroundColor(.secondary)
      }
    }
    .transition(.slide)
    .gesture(tap)
  }
}

#Preview {
  List() {
    LessonView(
      lesson:
        Lesson(
          text: "Операц.сист",
          time_start: Date(),
          time_end: Date(),
          additional:
            AdditionalLesson(
              is_online: true,
              type: LessonType.exam,
              teacher_name: "Андреев И.В."
            )
        )
    )
    LessonView(
      lesson:
        Lesson(
          text: "Операц.сист",
          time_start: Date(),
          time_end: Date(),
          additional:
            AdditionalLesson(
              is_online: true,
              type: LessonType.lecture,
              teacher_name: "Андреев И.В."
            )
        )
    )
    LessonView(
      lesson:
        Lesson(
          text: "Операц.сист",
          time_start: Date(),
          time_end: Date(),
          additional:
            AdditionalLesson(
              is_online: true,
              type: LessonType.library_day,
              teacher_name: "Андреев И.В."
            )
        )
    )
    LessonView(
      lesson:
        Lesson(
          text: "Операц.сист",
          time_start: Date(),
          time_end: Date(),
          additional:
            AdditionalLesson(
              is_online: true,
              type: LessonType.consultation,
              teacher_name: "Андреев И.В."
            )
        )
    )
    LessonView(
      lesson:
        Lesson(
          text: "Операц.сист",
          time_start: Date(),
          time_end: Date(),
          additional:
            AdditionalLesson(
              is_online: false,
              type: LessonType.project_work,
              location: "МС-45",
              teacher_name: "Андреев И.В."
            )
        )
    )
    LessonView(
      lesson:
        Lesson(
          text: "Операц.сист",
          time_start: Date(),
          time_end: Date(),
          additional:
            AdditionalLesson(
              is_online: false,
              type: LessonType.subject_report,
              teacher_name: "Андреев И.В."
            )
        )
    )
  }
  .listStyle(.plain)
  .listRowSeparator(.hidden)
  .listSectionSeparator(.hidden)
}
