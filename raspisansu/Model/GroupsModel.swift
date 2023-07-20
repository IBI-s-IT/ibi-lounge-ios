//
//  GroupsModel.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 24.06.2023.
//

import Foundation
import SwiftUI
import SwiftData

struct Groups: Codable {
  var response: [Group];
}

struct Group: Codable {
  var id: String;
  var name: String;
}

enum EducationLevel: String, CaseIterable {
  case undergraduate
  case specialty
  case magistracy
  case postgraduate
  case additionals
}

enum GroupsModelErrors: Error {
  case networkError
  case serverError
}

class GroupsModel: ObservableObject {
  @Published private(set) var data: Groups?
  @Published private(set) var error: GroupsModelErrors?
  @Published private(set) var isLoading: Bool = false
  @AppStorage("lastEduLevel") var educationLevel: EducationLevel = .undergraduate {
    willSet {
      Task.init {
        await update()
      }
    }
  }
  @AppStorage("lastGroup") var group: String = "2352"
  
  func update() async {
    DispatchQueue.main.async {
      self.isLoading = true;
    }
    do {
      guard let url = URL(string: "https://rasp-back.utme.space/groups?education_level=\(educationLevel.rawValue)") else {
        fatalError("Missing URL")
      }
      
      let urlRequest = URLRequest(url: url)
      
      let (data, response) = try await URLSession.shared.data(for: urlRequest)
      guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        throw GroupsModelErrors.serverError
      }
      
      let decoder = JSONDecoder()
      let decodedData = try decoder.decode(Groups.self, from: data)
      
      DispatchQueue.main.async {
        self.isLoading = false;
        self.data = decodedData
      }
      
    } catch GroupsModelErrors.serverError {
      self.error = .serverError
    } catch {
      if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
        self.error = .networkError
      } else {
        print("Error fetching data from rasp-back: \(error)")
      }
      print("Error fetching data from rasp-back: \(error)")
    }
  }
  
  init() {
    Task.init {
      await self.update()
    }
  }
}
