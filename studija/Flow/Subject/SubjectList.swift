import SwiftUI
import CoreData

struct SubjectList: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Subject.title, ascending: true)],
        animation: .default
    ) private var subjects: FetchedResults<Subject>
    @Binding var navPath: NavigationPath
    @State var searchText = ""
    let context: SubjectSelectionContext?
    var filteredSubjects: [Subject] {
        if searchText.isEmpty {
            return Array(subjects)
        } else {
            return subjects.filter { ($0.title ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
            ScrollView {
                VStack(spacing: 12) {
                    SearchField(searchText: $searchText)

                    if filteredSubjects.isEmpty {
                        EmptyListView(text: "No subjects")
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredSubjects, id: \.id) { subject in
                                SubjectCard(subject, navPath: $navPath, onSelect: context == nil ? nil : { chosen in
                                    context?.onSelect(chosen)
                                })
                            }
                        }
                    }
                }.padding(.horizontal, 16)
            }
        .navigationTitle(Text("Subjects"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    navPath.append(AppPaths.newSubject)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .background(Color.appBackground)
    }
}
