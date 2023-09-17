import SwiftUI

struct SchedulesDayNavigator: View {
  @EnvironmentObject var weekStore: WeekStore
  @EnvironmentObject var settings: SettingsModel;
  @State var days: DaysRequestResult = .error(.loading)
  @State var highlightedDay: [Date] = []
  @State private var taskId: UUID = .init()
  
  func fetch() async {
    self.days = .error(.loading)
    
    let start = weekStore.isWholeWeek ? weekStore.weeks[1].dates.first! : weekStore.selectedDate;
    let end = weekStore.isWholeWeek ? weekStore.weeks[1].dates.last! : weekStore.selectedDate;
    
    days = await Requests().fetchSchedules(
      from: start,
      to: end,
      group: settings.group
    )
  }
  
  var body: some View {
    NavigationView {
      ScrollViewReader { reader in
        Group {
          switch days {
          case .response(let result):
            AnyView(
              ScrollView {
                ForEach(result.response!, id: \.self.date) { day in
                  DayView(
                    day: day,
                    lightIsOn: highlightedDay.contains(day.date)
                  )
                }
              }
                .refreshable {
                  taskId = .init()
                }
            )
          case .error(let error):
            AnyView(TransientStatusNew(error: error) {
              taskId = .init()
            })
          }
        }
#if os(iOS)
        .listStyle(.insetGrouped)
#endif
        .onChange(of: weekStore.selectedDate) { [oldValue = weekStore.selectedDate] newValue in
          if weekStore.isWholeWeek {
            if !newValue.isInSameWeek(as: oldValue) {
              taskId = .init()
            } else {
              withAnimation {
                reader.scrollTo(newValue, anchor: .top)
                
                highlightedDay.append(newValue)
              }
              Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                withAnimation {
                  if let index = highlightedDay.firstIndex(of: newValue) {
                    highlightedDay.remove(at: index)
                  }
                }
              }
            }
          } else {
            taskId = .init()
          }
        }
        .onChange(of: weekStore.isWholeWeek) { value in
          taskId = .init()
        }
        .task(id: taskId) {
          await fetch()
        }
        .safeAreaInset(edge: .bottom, content: {
          VStack(spacing: 10) {
            WeekHeaderView()
              .padding(.horizontal, 16)
            WeeksTabView() { week in
              WeekView(week: week)
            }
          }
          .padding(.vertical, 10)
          .background(.regularMaterial)
        })
      }
      .navigationTitle("main.title")
    }
  }
}

struct SchedulesDayNavigator_Previews: PreviewProvider {
  static var previews: some View {
    SchedulesDayNavigator()
      .environmentObject(WeekStore())
      .environmentObject(SettingsModel())
  }
}
