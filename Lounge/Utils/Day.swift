//
//  Day.swift
//  LoungeApp
//
//  Created by g.gorbovskoy on 21.08.2023.
//

import Foundation

func dayToText(day: Day) -> String {
  var result = "\(NSLocalizedString("trasfer.title \(day.date.formatted(date: .long, time: .omitted))", comment: ""))\n"
  print(result)
  return result
}
