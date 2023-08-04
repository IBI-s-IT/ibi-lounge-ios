//
//  GradesModel.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 24.06.2023.
//

import Foundation
import SwiftUI

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


enum GradeValidationStatus {
  case pinEmpty
  case lastNameEmpty
  case pinCount
  case lastNameCount
  case okay
}

enum GradeErrors: Error {
  case serverError
}

class GradesModel: ObservableObject {
  @AppStorage("pin") var pin: String = "" {
    willSet {
      self.validationStatus = self.validate()
    }
  }
  @AppStorage("lastName") var lastName: String = "" {
    willSet {
      self.validationStatus = self.validate()
    }
  }

  @Published private(set) var data: Grades?
  @Published private(set) var validationStatus: GradeValidationStatus = .okay
  @Published private(set) var isLoading: Bool = false
  @Published private(set) var error: Errors?;
  @Published private(set) var isEmpty: Bool = false
  
  init() {
    self.error = nil;
    self.validationStatus = self.validate()
    if self.validationStatus == .okay {
      Task.init {
        await self.update();
      }
    }
  }
  
  func update() async {
    DispatchQueue.main.sync {
      self.isLoading = true;
      self.isEmpty = false;
      self.error = nil;
    }
    
    do {
      let pinEnc = pin.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
      let lnEnc = lastName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
      guard let url = URL(string: "https://rasp-back.utme.space/grades?pin=\(pinEnc!)&last_name=\(lnEnc!)") else {
        fatalError("Missing URL")
      }
      let urlRequest = URLRequest(url: url)
      
      let (data, response) = try await URLSession.shared.data(for: urlRequest)
      guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        self.isLoading = false;
        self.error = .bad_error;
        return;
      }
      
      let decoder = JSONDecoder()
      let decodedData = try decoder.decode(Grades.self, from: data)

      DispatchQueue.main.async {
        self.isLoading = false
        
        if decodedData.response.isEmpty {
          self.isEmpty = true
        }
        
        self.data = decodedData
      }
    } catch GradeErrors.serverError {
      self.error = .bad_error;
    } catch {
      DispatchQueue.main.sync {
        self.isLoading = false;
        if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
          self.error = .network_error;
        } else {
          self.error = .bad_error;
          print("[GradesModel] Error fetching data from rasp-back: \(error)")
        }
      }
    }
  }
  
  func validate() -> GradeValidationStatus {
    if self.pin.isEmpty {
      return .pinEmpty
    }
    
    if self.pin.count != 5 {
      return .pinCount
    }
    
    if self.lastName.isEmpty {
      return .lastNameEmpty
    }
    
    if self.lastName.count < 3 {
      return .lastNameCount
    }
    
    return .okay;
  }
}
