//
//  daily_widgetBundle.swift
//  daily-widget
//
//  Created by g.gorbovskoy on 05.08.2023.
//

import WidgetKit
import SwiftUI

extension View {
  func widgetBackground(_ color: Color) -> some View {
    //if #available(iOSApplicationExtension 17.0, macOSApplicationExtension 14.0, *) {
    //  return containerBackground(color, for: .widget)
    //} else {
      return background(color)
    //}
  }
}

struct DailyWidgetTimelineEntry: TimelineEntry {
  let date: Date
  let lessons: [Lesson]?
  let error: Errors?
  let dayIndex: Int;
  let isEmpty: Bool;
  let left: Int;
}

struct DailyWidgetTimelineProvider: TimelineProvider {
  typealias Entry = DailyWidgetTimelineEntry
  let schedules: DaysRequestResult = .error(.unknown_error)
  
  // Provides a timeline entry representing a placeholder version of the widget.
  func placeholder(in context: Context) -> DailyWidgetTimelineEntry {
    return DailyWidgetTimelineEntry(
      date: .now,
      lessons: [.init(text: "ЛинАлгИГеом", time_start: .now, time_end: .now, additional: .init(is_online: false, type: .consultation, location: "МС-34", teacher_name: "Павлушеов И.В."))],
      error: nil,
      dayIndex: 0,
      isEmpty: false,
      left: 2
    )
  }
  
  // Provides a timeline entry that represents the current time and state of a widget.
  func getSnapshot(in context: Context, completion: @escaping (DailyWidgetTimelineEntry) -> Void) {
    func getSnapshot(in context: Context, completion: @escaping (DailyWidgetTimelineEntry) -> Void) {
      completion(
        DailyWidgetTimelineEntry(
          date: Date(),
          lessons: [.init(text: "ЛинАлгИГеом", time_start: .now, time_end: .now, additional: .init(is_online: false, type: .consultation, location: "МС-34", teacher_name: "Павлушков И.В."))],
          error: nil,
          dayIndex: 0,
          isEmpty: false,
          left: 0
        )
      )
    }
  }
  
  // Provides an array of timeline entries for the current time and, optionally, any future times to update a widget.
  func getTimeline(in context: Context, completion: @escaping (Timeline<DailyWidgetTimelineEntry>) -> Void) {
    let settings = SettingsModel();
    
    Task {
      do {
        let result = await Requests().fetchSchedules(from: .now, to: Date().advanced(by: 3600 * 24), group: settings.group);
        
        switch result {
        case .error(let error):
          let entry = DailyWidgetTimelineEntry(date: Date(), lessons: [], error: error, dayIndex: 1, isEmpty: false, left: 0)
          let timeline = Timeline(entries: [entry], policy: .after(Date().getNext15Minutes()))
          completion(timeline)
        case .response(let response):
          let days = response.response;
          
          let firstDayIncomplete = days![0].lessons.filter { first in
            return !(first.time_end < .now);
          }
          
          var nextDayIncomplete: [Lesson] = [];
          
          if days?.count == 2 {
            nextDayIncomplete = days![1].lessons.filter { second in
              return !(second.time_end < .now);
            }
          }
          
          var lessons = !firstDayIncomplete.isEmpty ? firstDayIncomplete : nextDayIncomplete;
          let dayIndex = !firstDayIncomplete.isEmpty ? 0 : 1;
          var left = 0;
          
          let lesCount = lessons.count;
          
          if lesCount > 2 {
            lessons = Array(lessons[0...1])
            left = lesCount - 2;
          }
          
          let entry = DailyWidgetTimelineEntry(date: Date(), lessons: lessons, error: nil, dayIndex: dayIndex, isEmpty: lessons.isEmpty, left: left)
          let timeline = Timeline(entries: [entry], policy: .after(Date().getNext15Minutes()))
          
          completion(timeline)
        }
      }
    }
  }
}

struct DailyWidgetEntryView: View {
  var entry: DailyWidgetTimelineProvider.Entry
  
  var body: some View {
    VStack(spacing: 0) {
      Text(entry.dayIndex == 0 ? "Пары на сегодня" : "Пары на завтра")
        .font(.caption)
        .fontWeight(.medium)
        .foregroundStyle(.blue)
        .frame(maxWidth: .infinity)
        .padding(.top, 6)
        .padding(.bottom, 4)
      VStack(alignment: .leading, spacing: 6) {
        if entry.error != nil {
          if (entry.error == .no_schedules) {
            NoSchedules()
          } else {
            Image(systemName: entry.error!.icon)
              .resizable(resizingMode: .stretch)
              .frame(width: 32, height: 32)
            Text(LocalizedStringKey(entry.error!.title))
          }
        } else if entry.isEmpty {
          NoSchedules()
        } else {
          ForEach(entry.lessons!) { lesson in
            WidgetLesson(lesson: lesson)
          }
          
          if entry.left != 0 {
            Text(LocalizedStringKey("widget.left \(String(entry.left))"))
              .font(.caption2)
              .foregroundStyle(.tertiary)
          }
        }
      }
      .padding(.all, 11)
      .frame(
        minWidth: 0,
        maxWidth: .infinity,
        minHeight: 0,
        maxHeight: 148,
        alignment: .topLeading
      )
      .background(Color("BackgroundPrimary"))
      .cornerRadius(20)
    }
    .widgetBackground(Color("BackgroundSecondary"))
  }
}

@main
struct DailyWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "space.utme.raspisansu.daily-widget",
      provider: DailyWidgetTimelineProvider()) { entry in
        DailyWidgetEntryView(entry: entry)
      }
      .configurationDisplayName("widget.name")
      .description("widget.description")
      .supportedFamilies([.systemSmall, .systemMedium])
//      .contentMarginsDisabled()
  }
}
