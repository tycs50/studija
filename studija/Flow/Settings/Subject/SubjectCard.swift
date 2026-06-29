import SwiftUI

struct SubjectCard: View {
    let item: Subject
    @Binding var navPath: NavigationPath
    let onSelect: ((Subject) -> Void)?

    init(item: Subject, navPath: Binding<NavigationPath>, onSelect: ((Subject) -> Void)? = nil) {
        self.item = item
        self._navPath = navPath
        self.onSelect = onSelect
    }

    var body: some View {
        Button(action: {
            if let onSelectClosure = onSelect {
                onSelectClosure(item)
                navPath.removeLast()
            } else {
                navPath.append(item)
            }
        }) {
            HStack(alignment: .top) {
                Color(hex: item.color ?? "")
                    .frame(width: 3)
                    .cornerRadius(5)

                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title ?? "")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .modifier(RoundedBackground())
        }
        .buttonStyle(PressButtonStyle())
    }
}
