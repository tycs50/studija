import SwiftUI

struct SettingsRow: View {
    let title: String
    var icon: String? = nil
    var route: AppPaths? = nil
    var action: (() -> Void)? = nil

    @Binding var navPath: NavigationPath

    private var isInteractive: Bool {
        route != nil || action != nil
    }

    var body: some View {
        if isInteractive {
            Button(action: {
                if let route = route {
                    navPath.append(route)
                } else {
                    action?()
                }
            }) {
                content
            }
            .buttonStyle(.plain)
        } else {
            content
        }
    }

    private var content: some View {
        HStack(spacing: 14) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 24, alignment: .center)
            }

            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            if isInteractive {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.3))
            }
        }
        .modifier(RoundedBackground())

    }
}
