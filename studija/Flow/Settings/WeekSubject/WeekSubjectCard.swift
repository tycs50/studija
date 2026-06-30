import SwiftUI

struct WeekSubjectCard: View {
    @ObservedObject var item: WeekSubject
    @Binding var navPath: NavigationPath

    var body: some View {
        Button(action: {
            navPath.append(item)
        }) {
            HStack(alignment: .top, spacing: 10) {
                Color(hex: item.subject?.color ?? "")
                    .frame(width: 5)
                    .cornerRadius(5)

                VStack(alignment: .leading, spacing: 8) {
                    if let type = item.type {
                        SubjectTypeBadge(type: type)
                    }

                    Text(item.subject?.title ?? "")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)

                    VStack(alignment: .leading, spacing: 2) {
                        if let classroom = item.classroom, !classroom.isEmpty {
                            Label {
                                Text(classroom)
                            } icon: {
                                Image(systemName: "map.fill")
                                    .frame(width: 20)
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        }

                        if let teacher = item.teacher, !teacher.isEmpty {
                            Label {
                                Text(teacher)
                            } icon: {
                                Image(systemName: "graduationcap.fill")
                                    .frame(width: 20)
                            }
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                        }
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(item.formattedStartTime)
                        .font(.system(size: 18, weight: .bold))

                    Text(item.formattedEndTime)
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.top, 4)
            }
            .modifier(RoundedBackground())
        }
        .buttonStyle(PressButtonStyle())
    }

    private func SubjectTypeBadge(type: SubjectType) -> some View {
        HStack(spacing: 4) {
            Image(systemName: type.iconName ?? "")
            Text(type.name?.uppercased() ?? "")
        }
        .font(.footnote)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(hex: type.colorHex ?? "").opacity(0.15))
        .foregroundColor(Color(hex: type.colorHex ?? ""))
        .cornerRadius(6)
    }
}
