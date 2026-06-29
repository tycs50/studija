import SwiftUI

struct InfinitePageView<Content: View>: View {
    @Binding var selection: Int
    @ViewBuilder let content: (Int) -> Content

    @State private var internalSelection: Int
    @State private var visibleIndices: [Int]

    private let buffer = 3

    init(selection: Binding<Int>, @ViewBuilder content: @escaping (Int) -> Content) {
        self._selection = selection
        self._internalSelection = State(initialValue: selection.wrappedValue)

        let initial = selection.wrappedValue
        self._visibleIndices = State(initialValue: Array((initial - 3)...(initial + 3)))
        self.content = content
    }

    var body: some View {
        TabView(selection: $internalSelection) {
            ForEach(visibleIndices, id: \.self) { index in
                content(index)
                    .tag(index)
                    .opacity(index == internalSelection ? 1 : 0)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: internalSelection) { newValue in
            if selection != newValue {
                selection = newValue
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                recenter(around: newValue)
            }
        }
        .onChange(of: selection) { newValue in
            if newValue != internalSelection {
                handleExternalJump(to: newValue)
            }
        }
    }

    private func handleExternalJump(to targetIndex: Int) {
        if !visibleIndices.contains(targetIndex) {
            if let currentIndex = visibleIndices.firstIndex(of: internalSelection) {
                if targetIndex > internalSelection {
                    let replaceIndex = min(currentIndex + 1, visibleIndices.count - 1)
                    visibleIndices[replaceIndex] = targetIndex
                } else {
                    let replaceIndex = max(currentIndex - 1, 0)
                    visibleIndices[replaceIndex] = targetIndex
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation(.easeInOut(duration: 0.3)) {
                internalSelection = targetIndex
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                recenter(around: targetIndex)
            }
        }
    }

    private func recenter(around center: Int) {
        let newIndices = Array((center - buffer)...(center + buffer))
        if visibleIndices != newIndices {
            visibleIndices = newIndices
        }
    }
}

#Preview {
    struct Testpica: View {
        @State var sel = 1

        var body: some View {
            InfinitePageView(selection: $sel) { i in
                VStack {
                    Text(i.description)

                    HStack {
                        Button {
                            sel -= 100
                        } label: {
                            Text("-")
                        }

                        Button {
                            sel += 100
                        } label: {
                            Text("+")
                        }
                    }.font(.largeTitle)
                    .fontWeight(.bold)
                }
            }
        }
    }

    return Testpica()
}
