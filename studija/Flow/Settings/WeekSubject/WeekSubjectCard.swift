import SwiftUI

struct WeekSubjectCard: View {
    let item: WeekSubject
    @Binding var navPath: NavigationPath

    var body: some View {
        Button(action: {
            navPath.append(item)
        }) {
            HStack(alignment: .top) {
                Color(hex: item.subject?.color ?? "")
                    .frame(width: 3)
                    .cornerRadius(5)

                VStack(alignment: .leading, spacing: 8) {
                    Text(item.subject?.title ?? "")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.classroom ?? "")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)

                        Text(item.teacher ?? "")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color.white.opacity(0.5))
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(item.formattedStartTime)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)

                    Text(item.formattedEndTime)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.white.opacity(0.5))
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(Color(white: 0.11))
            .cornerRadius(18)
        }
        .buttonStyle(PressButtonStyle())
    }
}
