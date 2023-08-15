//
//  NewSchedulesModel.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 06.08.2023.
//

import Foundation

let schedulesEndpoint = "https://rasp-back.utme.space/schedules";
let groupsEndpoint = "https://rasp-back.utme.space/groups";
let gradesEndpoint = "https://rasp-back.utme.space/grades"

struct Groups: Codable {
  var response: [EduGroup];
}

struct EduGroup: Codable {
  var id: String;
  var name: String;
}

enum GroupsResult {
  case result(Groups)
  case error(Errors)
}

struct Grades: Codable {
  var response: [Grade];
}

struct Grade: Codable, Identifiable {
  let id = UUID().uuidString
  var name: String;
  var type: GradeType;
  var grade: GradeGrade;
  
  enum CodingKeys: CodingKey {
    case name
    case type
    case grade
  }
}

enum GradeType: String, Codable {
  case subject_report_with_grade
  case subject_report
  case exam
  case online_course_work
  case offline_course_work
  case unknown
}

enum GradeGrade: String, CaseIterable, Codable {
  case failed
  case passed
  case absence
  case not_admitted
  case two = "2"
  case three = "3"
  case four = "4"
  case fice = "5"
  case unknown
}

enum GradesResult {
  case result(Grades)
  case error(Errors)
}

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

  var emoji: String {
    switch self {
    case .practice:
      return "🔨"
    case .lecture:
      return "📖"
    case .library_day:
      return "📚"
    case .project_work:
      return "👥"
    case .exam:
      return "🚨"
    case .subject_report:
      return "⚠️"
    case .consultation:
      return "ℹ️"
    case .subject_report_with_grade:
      return "⚠️"
    }
  }
}

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
  case loading
  
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

class Requests {
  let decoder = JSONDecoder()

  init() {
    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full);
  }
  
  func fetchSchedules(from: Date = .now, to: Date = .now, group: String = "2352") async -> DaysRequestResult {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YYYY";
    
    do {
      guard let url = URL(string: "\(schedulesEndpoint)?dateStart=\(dateFormatter.string(from: from))&dateEnd=\(dateFormatter.string(from: to))&group=\(group)") else {
        fatalError("Missing URL")
      }
      let urlRequest = URLRequest(url: url)
      
      let (data, response) = try await URLSession.shared.data(for: urlRequest)
      guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        return .error(.bad_error);
      }

      let decodedData = try decoder.decode(DaysRequestResult.self, from: data)
      return decodedData;
    } catch {
      if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
        switch err.code {
        case URLError.Code.notConnectedToInternet:
          return .error(.network_error)
        case URLError.Code.timedOut:
          return .error(.timed_out)
        default:
          return .error(.unknown_error);
        }
      } else {
        print("[fetchSchedules] Error fetching data from rasp-back: \(error)")
        return .error(.unknown_error)
      }
    }
  }
  
  func fetchGroups(educationLevel: EducationLevel) async -> GroupsResult {
    do {
      guard let url = URL(string: "\(groupsEndpoint)?education_level=\(educationLevel.rawValue)") else {
        fatalError("Missing URL")
      }
      
      let urlRequest = URLRequest(url: url)
      
      let (data, response) = try await URLSession.shared.data(for: urlRequest)
      guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        return .error(.bad_error)
      }
      
      let decoder = JSONDecoder()
      let decodedData = try decoder.decode(Groups.self, from: data)
      
      return .result(decodedData)
    } catch {
      if let err = error as? URLError {
        switch err.code {
        case URLError.Code.notConnectedToInternet:
          return .error(.network_error)
        case URLError.Code.timedOut:
          return .error(.timed_out)
        default:
          return .error(.unknown_error);
        }
      } else {
        print("[fetchGroups] Error fetching data from rasp-back: \(error)")
        return .error(.bad_error)
      }
    }
  }
  
  func fetchGrades(pin: String, lastName: String) async -> GradesResult {
    do {
      let pinEnc = pin.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
      let lnEnc = lastName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);

      guard let url = URL(string: "\(gradesEndpoint)?pin=\(pinEnc!)&last_name=\(lnEnc!)") else {
        fatalError("Missing URL")
      }
      let urlRequest = URLRequest(url: url)
      
      let (data, response) = try await URLSession.shared.data(for: urlRequest)
      guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        return .error(.unknown_error)
      }

      let decodedData = try decoder.decode(Grades.self, from: data)
      
      if decodedData.response.isEmpty {
        return .error(.no_grades)
      }

      return .result(decodedData)
    } catch {
      if let err = error as? URLError {
        switch err.code {
        case URLError.Code.notConnectedToInternet:
          return .error(.network_error)
        case URLError.Code.timedOut:
          return .error(.timed_out)
        default:
          return .error(.unknown_error);
        }
      } else {
        print("[fetchGrades] Error fetching data from rasp-back: \(error)")
        return .error(.bad_error)
      }
    }
  }
}
