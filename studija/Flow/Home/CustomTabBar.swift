import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack {
            Spacer()
            ForEach(Tab.allCases, id: \.self) { tab in
                TabItemButton(tab: tab, selectedTab: $selectedTab)
                Spacer()
            }
        }
        .padding(.vertical, 12)
        .background(
            Color(white: 0.12)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: -5)
        )
        .cornerRadius(24)
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }
}

struct TabItemButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab

    private var isSelected: Bool { selectedTab == tab }

    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: tab.iconName)
                    .symbolVariant(isSelected ? .fill : .none)
                    .font(.system(size: 20))

                Text(tab.label)
                    .font(.system(size: 11, weight: isSelected ? .medium : .regular))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.4))
            .frame(width: 65, height: 44)
        }
        .buttonStyle(.plain)
    }
}
