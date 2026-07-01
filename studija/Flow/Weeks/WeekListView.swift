import SwiftUI
import CoreData

struct WeekListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(ScheduleManager.self) private var manager

    private let schedule: Schedule
    @State private var viewModel: WeekViewModel
    @State private var searchText = ""
    @State private var isShowingEditScreen = false

    @FetchRequest private var weeks: FetchedResults<Week>
    @Binding var navPath: NavigationPath

    init(navPath: Binding<NavigationPath>, schedule: Schedule) {
        self.schedule = schedule
        self._navPath = navPath
        self._viewModel = State(initialValue: WeekViewModel(schedule: schedule))

        let predicate = NSPredicate(format: "schedule == %@", schedule)
        self._weeks = FetchRequest(
            entity: Week.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Week.weekIndex, ascending: true)],
            predicate: predicate,
            animation: .default
        )
    }

    var filteredWeeks: [Week] {
        if searchText.isEmpty {
            return Array(weeks)
        } else {
            return weeks.filter { ($0.title ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
            ScrollView {
                VStack(spacing: 12) {
                    SearchField(searchText: $searchText)

                    if filteredWeeks.isEmpty {
                        EmptyListView(text: "No weeks")
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredWeeks) { week in
                                weekCard(for: week)
                            }
                        }
                    }
                }.padding(.horizontal, 16)
                //                .searchable(text: $searchText,
                //                            placement: .navigationBarDrawer(displayMode: .always),
                //                            prompt: Text("Search"))
            }
        .navigationTitle(schedule.title ?? "Schedule")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.prepareCreate()
                    isShowingEditScreen = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationDestination(isPresented: $isShowingEditScreen) {
            WeekView(viewModel: viewModel, isShowing: $isShowingEditScreen)
        }
        .background(Color.appBackground)
    }

    @ViewBuilder
    private func weekCard(for week: Week) -> some View {
        let isCurrent = (manager.currentWeekID == week.id?.uuidString)

        Button {
            navPath.append(week)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(week.title ?? "Untitled Week")
                        .font(.system(size: 18, weight: .bold))

                    if isCurrent {
                        Text("Current week")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Button {
                    viewModel.prepareEdit(for: week, manager: manager)
                    isShowingEditScreen = true
                } label: {
                    Image(systemName: "pencil")
                        .frame(width: 44, height: 44)
                }.buttonStyle(.plain)
            }
            .modifier(RoundedBackground())
        }.buttonStyle(BounceButtonStyle())
    }
}
