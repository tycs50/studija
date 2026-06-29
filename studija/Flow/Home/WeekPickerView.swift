import SwiftUI

struct WeekPickerView: View {
    @Binding var selectedDate: Date
    @State private var selectedWeek: Int = 0

    private let cal: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.firstWeekday = 2
        return c
    }()

    var body: some View {
        InfinitePageView(selection: $selectedWeek) { week in
            weekRow(for: week)
        }
        .frame(height: 80)
        .onChange(of: selectedDate) { newDate in
            let targetWeek = weekIndex(for: newDate)
            if selectedWeek != targetWeek {
                selectedWeek = targetWeek
            }
        }
        .onAppear {
            selectedWeek = weekIndex(for: selectedDate)
        }
    }

    @ViewBuilder
    private func weekRow(for weekIdx: Int) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<7, id: \.self) { dayOffset in
                let date = dateAt(weekIdx: weekIdx, dayOffset: dayOffset)

                DayCell(
                    date: date,
                    isSelected: cal.isDate(date, inSameDayAs: selectedDate),
                    isToday: cal.isDateInToday(date),
                    isSunday: cal.component(.weekday, from: date) == 1,
                    shortLabel: shortLabel(date),
                    dayNumber: cal.component(.day, from: date)
                ) {
                    withAnimation(.spring(response: 0.23, dampingFraction: 0.75)) {
                        selectedDate = date
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }

    private func dateAt(weekIdx: Int, dayOffset: Int) -> Date {
        let baseMonday = monday(of: Date())
        let daysToAdd = (weekIdx * 7) + dayOffset
        return cal.date(byAdding: .day, value: daysToAdd, to: baseMonday)!
    }

    private func weekIndex(for date: Date) -> Int {
        let startOfCurrentWeek = monday(of: Date())
        let startOfTargetWeek = monday(of: date)
        let components = cal.dateComponents([.day], from: startOfCurrentWeek, to: startOfTargetWeek)
        let days = components.day ?? 0
        return days / 7
    }

    private func monday(of date: Date) -> Date {
        var comps = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        comps.weekday = 2
        return cal.date(from: comps)!
    }

    private func shortLabel(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "EEE"
        return f.string(from: date)
    }
}

private struct DayCell: View {
    let date:       Date
    let isSelected: Bool
    let isToday:    Bool
    let isSunday:   Bool
    let shortLabel: String
    let dayNumber:  Int
    let onTap:      () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(shortLabel)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(labelColor)

                Text("\(dayNumber)")
                    .font(.system(size: 16, weight: isSelected ? .bold : .semibold))
                    .foregroundStyle(numberColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 9)
            .background {
                if isSelected || isToday {
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .fill(badgeFill)
                }
            }
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.26, dampingFraction: 0.70), value: isSelected)
    }

    // MARK: Colours
    private var badgeFill: Color {
        if isSelected { return Color(white: 0.30) }
        if isToday    { return Color(white: 0.16) }
        return .clear
    }

    private var labelColor: Color {
        if isSelected { return .white }
        if isSunday   { return .red.opacity(0.85) }
        return .white.opacity(0.45)
    }

    private var numberColor: Color {
        if isSelected         { return .white }
        if isSunday           { return .red }
        if isToday            { return .white.opacity(0.85) }
        return .white.opacity(0.65)
    }
}

#Preview {
    struct prev: View {
        @State var date = Date()

        var body: some View {
            WeekPickerView(selectedDate: $date)
        }
    }

    return prev()
}
