import SwiftUI

struct SubjectSelectionView: View {
    @Binding var navPath: NavigationPath
    var navDestination: AppPaths
    @Binding var selectedSubject: Subject?
    var text: String = "Select Subject"
    var allowCancelation: Bool = false

    var body: some View {
        Button(action: {
            navPath.append(navDestination)
        }) {
            VStack {
                if let subject = selectedSubject {
                    SubjectCard(subject, navPath: $navPath)
                        .disabled(true)
                        .overlay(alignment: .trailing, content: {
                            if allowCancelation {
                                Button(action: {
                                    withAnimation {
                                        selectedSubject = nil
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }.padding(.trailing, 16)
                            }
                        })
                } else {
                    HStack {
                        Spacer()

                        Text(text)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.secondary)

                        Spacer()
                    }
                    .padding(.vertical, 20)
                    .background(Color.appBackground)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.lightSelection, lineWidth: 2)
                    )
                }
            }
        }
    }
}
