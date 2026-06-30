import SwiftUI

struct SettingsView: View {
    @Binding var navPath: NavigationPath

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 12) {
                    SettingsRow(
                        title: "Schedules",
                        icon: "calendar",
                        route: AppPaths.scheduleList,
                        navPath: $navPath
                    )

                    SettingsRow(
                        title: "Subjects",
                        icon: "list.bullet",
                        route: AppPaths.subjectList(context: nil),
                        navPath: $navPath
                    )

                    SettingsRow(title: "Classes Types",
                                icon: "eyeglasses",
                                route: AppPaths.classesTypesList,
                                navPath: $navPath)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
