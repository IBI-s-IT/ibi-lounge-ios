//
//  Date+StartOfWeekEndOfWeek.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 18.06.2023.
//

import Foundation

extension Date: RawRepresentable {
  func monthToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "LLLL"
    return dateFormatter.string(from: self)
  }
  
  func toString(format: String) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar.current
    formatter.dateFormat = format
    
    return formatter.string(from: self)
  }
  
  var yesterday: Date {
    Calendar.current.date(byAdding: .day, value: -1, to: self)!
  }
  
  var tomorrow: Date {
    Calendar.current.date(byAdding: .day, value: 1, to: self)!
  }
  
  private func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
    var customCalendar = Calendar(identifier: .gregorian)
    customCalendar.firstWeekday = 2
    
    return customCalendar.isDate(self, equalTo: date, toGranularity: component)
  }
  
  func isInSameWeek(as date: Date) -> Bool {
    isEqual(to: date, toGranularity: .weekOfYear)
  }
  
  func isInSameDay(as date: Date) -> Bool {
    isEqual(to: date, toGranularity: .day)
  }
  
  public var rawValue: String {
    self.timeIntervalSinceReferenceDate.description
  }
  
  public init?(rawValue: String) {
    self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
  }

  var startOfWeek: Date {
    let gregorian = Calendar(identifier: .iso8601)
    return gregorian.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
  }
  
  var endOfWeek: Date {
    let gregorian = Calendar(identifier: .iso8601)
    return gregorian.date(byAdding: .day, value: 6, to: self.startOfWeek)!;
  }
  
  var startOfNextWeek: Date {
    let gregorian = Calendar(identifier: .iso8601)
    return gregorian.date(byAdding: .day, value: 1, to: self.endOfWeek)!;
  }
  
  var endOfNextWeek: Date {
    let gregorian = Calendar(identifier: .iso8601)
    return gregorian.date(byAdding: .day, value: 6, to: self.startOfNextWeek)!;
  }
  
  func startOfMonth() -> Date {
    return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
  }
  
  func endOfMonth() -> Date {
    return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
  }
  
  func startOfNextMonth() -> Date {
    let startNext = Calendar.current.date(byAdding: .month, value: 1, to: Date().startOfMonth())!;
    return startNext;
  }
  
  func endOfNextMonth() -> Date {
    return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfNextMonth())!
  }
  
  func getNext15Minutes() -> Date {
    let calendar = Calendar.current
    let nextHour = calendar.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
    return nextHour
  }
  
  func getJune7Date() -> Date {
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.year = calendar.component(.year, from: Date())
    dateComponents.month = 5
    dateComponents.day = 14
    
    guard let june7Date = calendar.date(from: dateComponents) else {
      return Date()
    }
    
    return june7Date
  }
}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
