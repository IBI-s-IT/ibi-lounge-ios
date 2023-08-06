//
//  Settings.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 06.08.2023.
//

import Foundation
import SwiftUI

enum FieldValidation {
  case empty
  case count
  case okay
}

enum EducationLevel: String, CaseIterable {
  case undergraduate
  case specialty
  case additionals
}

class SettingsModel: ObservableObject {
  @AppStorage("group") var group: String = "2352"
  @AppStorage("educationLevel") var educationLevel: EducationLevel = .undergraduate
  @AppStorage("pin") var pin: String = "" {
    willSet {
      self.pinValidity = self.validatePin()
    }
  }
  @AppStorage("lastName") var lastName: String = "" {
    willSet {
      self.lastNameValidity = self.validateLastName()
    }
  }
  private(set) var pinValidity: FieldValidation = .empty
  private(set) var lastNameValidity: FieldValidation = .empty
  
  func validatePin() -> FieldValidation {
    if self.pin.isEmpty {
      return .empty
    }
    
    if self.pin.count != 5 {
      return .count
    }
    
    return .okay;
  }
  
  func validateLastName() -> FieldValidation {
    if self.lastName.isEmpty {
      return .empty
    }
    
    if self.lastName.count < 3 {
      return .count
    }
    
    return .okay
  }
  
  init() {
    self.pinValidity = self.validatePin()
    self.lastNameValidity = self.validateLastName()
  }
}
