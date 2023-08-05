//
//  daily_widgetBundle.swift
//  daily-widget
//
//  Created by g.gorbovskoy on 05.08.2023.
//

import WidgetKit
import SwiftUI

struct ExampleTimelineEntry: TimelineEntry {
  let date: Date
  let day: Day?
  let error: Errors?
}

struct ExampleTimelineProvider: TimelineProvider {
  typealias Entry = ExampleTimelineEntry
  let schedules = SchedulesModel();
  
  // Provides a timeline entry representing a placeholder version of the widget.
  func placeholder(in context: Context) -> ExampleTimelineEntry {
    return ExampleTimelineEntry(
      date: .now,
      day: .init(date: .now, lessons: [.init(text: "Алгоритмы", time_start: .now, time_end: .now)]),
      error: nil
    )
  }
  
  // Provides a timeline entry that represents the current time and state of a widget.
  func getSnapshot(in context: Context, completion: @escaping (ExampleTimelineEntry) -> Void) {
    func getSnapshot(in context: Context, completion: @escaping (ExampleTimelineEntry) -> Void) {
      completion(
        ExampleTimelineEntry(
          date: Date(),
          day: .init(date: .now, lessons: [.init(text: "Загрузка...", time_start: .now, time_end: .now)]),
          error: nil
        )
      )
    }
  }
  
  // Provides an array of timeline entries for the current time and, optionally, any future times to update a widget.
  func getTimeline(in context: Context, completion: @escaping (Timeline<ExampleTimelineEntry>) -> Void) {
    schedules.rangeMode = 4;
    schedules.dateFrom = .now;
    schedules.dateTo = .now;
    
    Task {
      do {
        await schedules.fetchDays();
        
        if schedules.days != nil || schedules.daysError != nil {
          let entry = ExampleTimelineEntry(date: Date(), day: schedules.days?.response?.first, error: schedules.daysError)
          let timeline = Timeline(entries: [entry], policy: .after(Date().getNext15Minutes()))
          completion(timeline)
        }
      }
    }
  }
}

struct ExampleWidgetEntryView: View {
  var entry: ExampleTimelineProvider.Entry
  
  var body: some View {
    VStack {
      VStack(alignment: .leading, content: {
        Text(entry.date.formatted(date: .numeric, time: .omitted))
          .padding(.bottom, 1)
        if entry.error == nil {
          ForEach(entry.day!.lessons) { lesson in
            HStack(alignment: .top, content: {
              VStack(alignment: .leading) {
                Text(lesson.time_start.formatted(date: .omitted, time: .shortened))
              }
              VStack(alignment: .leading) {
                HStack(alignment: .top) {
                  if lesson.additional?.type != nil {
                    Text("schedules.\(lesson.additional!.type!.rawValue)")
                  }
                  if lesson.additional?.location != nil {
                    Text("schedules.place \(lesson.additional!.location!)");
                  }
                }
                Text(lesson.text)
              }
            })
            .font(.caption)
          }
        } else {
          HStack {
            Image(systemName: entry.error!.icon)
            Text(LocalizedStringKey(entry.error!.title));
          }
        }
      })
      .padding()
    }
    .frame(
      minWidth: 0,
      maxWidth: .infinity,
      minHeight: 0,
      maxHeight: .infinity,
      alignment: .topLeading
    )
  }
}

@main
struct DailyWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "space.utme.raspisansu.daily-widget",
      provider: ExampleTimelineProvider()) { entry in
        ExampleWidgetEntryView(entry: entry)
      }
      .configurationDisplayName("Daily")
      .supportedFamilies([.systemSmall, .systemMedium])
  }
}
