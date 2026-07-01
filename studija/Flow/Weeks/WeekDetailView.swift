import SwiftUI
import CoreData

// MARK: - VIEW MODEL
@Observable
class WeekDetailViewModel {
    var searchText: String = ""
    var selectedDayIndex: Int = 0

    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
}

// MARK: - VIEW
struct WeekDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var week: Week
    @Binding var navPath: NavigationPath

    @State private var viewModel = WeekDetailViewModel()

    private var filteredSubjects: [WeekSubject] {
        let allSubjects = (week.subjects as? Set<WeekSubject>) ?? []

        return allSubjects
            .filter { $0.weekday == viewModel.selectedDayIndex }
            .filter { subject in
                if viewModel.searchText.isEmpty { return true }
                let title = subject.subject?.title ?? ""
                return title.localizedCaseInsensitiveContains(viewModel.searchText)
            }
            .sorted(by: { $0.startAsDate < $1.startAsDate })
    }

    var body: some View {
            VStack(spacing: 20) {
                SearchField(searchText: $viewModel.searchText)

                HStack(spacing: 0) {
                    ForEach(0..<viewModel.days.count, id: \.self) { index in
                        let isSelected = viewModel.selectedDayIndex == index

                        Text(viewModel.days[index])
                            .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                            .foregroundColor(isSelected ? .white : .primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(
                                Circle()
                                    .fill(isSelected ? .selectedDayBackground : Color.clear)
                                    .frame(width: 44, height: 44)
                            )
                            .onTapGesture {
                                withAnimation(.smooth(duration: 0.2)) {
                                    viewModel.selectedDayIndex = index
                                }
                            }
                    }
                }

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredSubjects) { subject in
                            WeekSubjectCard(item: subject, navPath: $navPath)
                        }
                    }
                }
            }.padding(.horizontal, 16)
        .navigationTitle(week.title ?? "Week")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    navPath.append(AppPaths.newWeekSubject(week: week, weekday: viewModel.selectedDayIndex))
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                }
            }
        }
        .background(Color.appBackground)
    }
}
