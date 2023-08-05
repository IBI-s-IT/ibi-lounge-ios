//
//  ModelData.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 18.06.2023.
//

import SwiftUI
import SwiftData

enum DaysRequestResult {
  case response(Days)
  case error(Errors)
}

extension DaysRequestResult: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let error = try? container.decode(RequestError.self) {
      self = .error(error.error)
    } else {
      self = .response(try container.decode(Days.self))
    }
  }
}

struct RequestError: Decodable {
  var error: Errors;
}

enum Errors: String, Codable {
  case bad_error
  case bad_error_159
  case bad_error_169
  case bad_error_184
  case bad_error_185
  case no_education_level_specified
  case no_schedules
  case no_groups
  case no_grades
  case unknown_error
  case network_error
  case timed_out
  
  var title: String {
    switch self {
    case .bad_error, .bad_error_159, .bad_error_169, .bad_error_184, .bad_error_185:
      return "error.unknown_error"
    default:
      return "error.\(self.rawValue)";
    }
  }
  
  var description: String {
    switch self {
    case .bad_error, .bad_error_159, .bad_error_169, .bad_error_184, .bad_error_185:
      return "error.unknown_error.desc"
    default:
      return "error.\(self.rawValue).desc";
    }
  }
  
  var icon: String {
    switch self {
    case .no_grades, .no_groups, .no_schedules:
      return "exclamationmark.bubble"
    case .network_error:
      return "wifi.slash"
    case .timed_out:
      return "exclamationmark.arrow.circlepath"
    default:
      return "questionmark.app.dashed"
    }
  }
}

enum ViewState {
  case loading
  case ready
}

extension Errors: Error {}

struct Days: Codable {
  var response: [Day]?;
}

struct Day: Codable {
  var date: Date;
  var lessons: Array<Lesson>;
  
  enum CodingKeys: CodingKey {
    case date
    case lessons
  }
}

struct Lesson: Codable, Identifiable {
  var text: String;
  var time_start: Date;
  var time_end: Date;
  
  var additional: AdditionalLesson?;
  
  var id: String {
    time_start.formatted(date: .numeric, time: .shortened) + (additional?.teacher_name ?? text)
  }
  
  enum CodingKeys: CodingKey {
    case text
    case time_start
    case time_end
    case additional
  }
}

struct AdditionalLesson: Codable, Identifiable {
  let id = UUID().uuidString
  var is_online: Optional<Bool>;
  var url: String?;
  var type: LessonType?;
  var subgroup: String?;
  var location: String?;
  var teacher_name: String?;
  var custom_time: CustomTime?;
  
  enum CodingKeys: CodingKey {
    case is_online
    case url
    case type
    case subgroup
    case location
    case teacher_name
    case custom_time
  }
}

struct CustomTime: Codable {
  var start: Date;
  var end: Date;
}

enum LessonType: String, Codable {
  case practice
  case lecture
  case library_day
  case project_work
  case exam
  case subject_report
  case consultation
  case subject_report_with_grade
}


enum someErrors: Error {
  case req_bad_code
}

class SchedulesModel: ObservableObject {
  @Published private(set) var days: Days?
  @Published private(set) var daysError: Errors?
  @Published private(set) var raspState: ViewState = .loading;
  @Published var dateFrom: Date = .now {
    willSet {
      Task.init {
        await fetchDays()
      }
    }
  }
  @Published var dateTo: Date = .now {
    willSet {
      Task.init {
        await fetchDays()
      }
    }
  }
  @AppStorage("lastRangeMode") var rangeMode: Int = 0 {
    willSet {
      Task.init {
        await fetchDays()
      }
    }
  }
  @AppStorage("lastGroup") var group: String = "2352" {
    willSet {
      Task.init {
        await fetchDays()
      }
    }
  }
  
  func fetchDays() async {
    DispatchQueue.main.sync {
      self.daysError = nil;
      self.raspState = .loading;
    }
    
    var startDate = Date().startOfWeek;
    var endDate = Date().endOfWeek;
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YYYY";
    
    switch rangeMode {
    case 0:
      startDate = Date().startOfWeek;
      endDate = Date().endOfWeek;
    case 1:
      startDate = Date().startOfNextWeek
      endDate = Date().endOfNextWeek
    case 2:
      startDate = Date().startOfMonth()
      endDate = Date().endOfMonth()
    default:
      startDate = dateFrom;
      endDate = dateTo;
    }
    
    do {
      guard let url = URL(string: "https://rasp-back.utme.space/schedules?dateStart=\(dateFormatter.string(from: startDate))&dateEnd=\(dateFormatter.string(from: endDate))&group=\(group)") else {
        fatalError("Missing URL")
      }
      let urlRequest = URLRequest(url: url)
      
      let (data, response) = try await URLSession.shared.data(for: urlRequest)
      guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        self.daysError = .bad_error;
        self.raspState = .ready;
        return;
      }
      
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
      let decodedData = try decoder.decode(DaysRequestResult.self, from: data)
      
      DispatchQueue.main.async {
        self.raspState = .ready
        
        switch decodedData {
        case .response(let days):
          self.days = days
        case .error(let error):
          self.daysError = error
        }
      }
    } catch {
      DispatchQueue.main.sync {
        self.raspState = .ready;
        if let _err = error as? URLError {
          self.daysError = .network_error
        } else if let err = error as? URLError, err.code  == URLError.Code.timedOut {
          self.daysError = .timed_out
        } else {
          self.daysError = .unknown_error
          print("[SchedulesModel] Error fetching data from rasp-back: \(error)")
        }
      }
    }
  }
  
  init() {
    Task.init {
      await self.fetchDays()
    }
  }
}
