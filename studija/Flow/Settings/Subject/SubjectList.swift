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

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $searchText)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .frame(height: 50)
                .background(Color(white: 0.15))
                .cornerRadius(12)
                .padding(.horizontal, 16)

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(subjects, id: \.id) { subject in
                            SubjectCard(item: subject, navPath: $navPath, onSelect: context == nil ? nil : { chosen in
                                context?.onSelect(chosen)
                            })
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
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
    }
}
