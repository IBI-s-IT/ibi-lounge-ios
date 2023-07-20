//
//  NetworkError.swift
//  raspisansu
//
//  Created by g.gorbovskoy on 23.06.2023.
//

import SwiftUI

struct TransientStatus: View {
  var action: () -> Void;
  var error: Errors?;
  var viewState: ViewState?;
  
  var body: some View {
    switch error {
    case .bad_error, .bad_error_159, .bad_error_169, .bad_error_184, .bad_error_185:
      ContentUnavailableView {
        Label("error.unknown_error", systemImage: "exclamationmark.bubble")
      } description: {
        VStack {
          Text("error.unknown_error.desc")
          Text("error.code \(error?.rawValue ?? "?")")
        }
      } actions: {
        Button(action: {
          action()
        }, label: {
          Text("error.try_again")
        })
      }
    case .no_education_level_specified:
      ContentUnavailableView {
        Label("error.no_edu_level", systemImage: "questionmark.square.dashed")
      } description: {
        Text("error.no_edu_level.desc")
      } actions: {
        Button(action: {
          action()
        }, label: {
          Text("error.try_again")
        })
      }
    case .no_data:
      ContentUnavailableView {
        Label("error.no_schedule", systemImage: "calendar.badge.exclamationmark")
      } description: {
        Text("error.no_schedule.desc")
      } actions: {
        Button(action: {
          action()
        }, label: {
          Text("error.try_again")
        })
      }
    case .unknown_error:
      ContentUnavailableView {
        Label("error.unknown_error", systemImage: "exclamationmark.triangle")
      } description: {
        Text("error.unknown_error.desc")
      } actions: {
        Button(action: {
          action()
        }, label: {
          Text("error.try_again")
        })
      }
    case nil:
      switch viewState {
      case .loading, .ready:
        HStack(alignment: .center, content: {
          Spacer()
          ProgressView()
          Spacer()
        })
        .padding()
      case .networkError:
        ContentUnavailableView {
          Label("error.no_network", systemImage: "wifi.slash")
        } description: {
          Text("error.no_network.desc")
        } actions: {
          Button(action: {
            action()
          }, label: {
            Text("error.try_again")
          })
        }
      case .enterData:
        ContentUnavailableView {
          Label("error.enter_data", systemImage: "person.fill.questionmark")
        } description: {
          Text("error.enter_data.desc")
        } actions: {
          Button(action: {
            action()
          }, label: {
            Text("error.try_again")
          })
        }
      case .timedOut:
        ContentUnavailableView {
          Label("error.timed_out", systemImage: "wifi.exclamationmark")
        } description: {
          Text("error.timed_out.desc")
        } actions: {
          Button(action: {
            action()
          }, label: {
            Text("error.try_again")
          })
        }
      case nil:
        HStack(alignment: .center, content: {
          Spacer()
          ProgressView()
          Spacer()
        })
        .padding()
      }
    }
  }
}

#Preview("networking issue", body: {
  TransientStatus(action: {
    print("pressed 'try again'")
  }, viewState: .networkError)
})

#Preview("bad errors", body: {
  TransientStatus(action: {
    print("pressed 'try again'")
  }, error: .bad_error)
})

#Preview("no edu_level", body: {
  TransientStatus(action: {
    print("pressed 'try again'")
  }, error: .no_education_level_specified)
})

#Preview("no data", body: {
  TransientStatus(action: {
    print("pressed 'try again'")
  }, error: .no_data)
})
