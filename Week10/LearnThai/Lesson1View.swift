import SwiftUI

struct Lesson1View: View {
    @Environment(\.dismiss) private var dismiss

    var onFinish: (() -> Void)? = nil

    private enum Page: Int, CaseIterable, Identifiable {
        case particles, examples, tip
        var id: Int { rawValue }
    }

    @State private var page: Page = .particles

    /// How far through the lesson pages the player is, from 0 to 1.
    private var progress: CGFloat {
        CGFloat(page.rawValue + 1) / CGFloat(Page.allCases.count)
    }

    private var isLastPage: Bool { page == Page.allCases.last }

    private struct Example: Identifiable {
        let id = UUID()
        let thai: String
        let romanized: String
    }

    private let examples = [
        Example(thai: "สวัสดีครับ / สวัสดีค่ะ", romanized: "sà-wàt-dii khráp / khâ · Hello"),
        Example(thai: "ขอบคุณครับ / ขอบคุณค่ะ", romanized: "khàwp-khun khráp / khâ · Thank you"),
        Example(thai: "กินอะไรดีคะ?", romanized: "kin à-rai dii khá? · What would you like to eat?")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
                .padding(.horizontal, 20)

            TabView(selection: $page) {
                ForEach(Page.allCases) { page in
                    ScrollView {
                        pageContent(page)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 4)
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .tag(page)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            VStack(spacing: 14) {
                pageDots
                navigationButtons
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .foregroundStyle(Color.lessonInk)
        .background(Color.lessonPaper.ignoresSafeArea())
    }

    // MARK: Pages

    @ViewBuilder
    private func pageContent(_ page: Page) -> some View {
        switch page {
        case .particles:
            VStack(alignment: .leading, spacing: 16) {
                intro

                HStack(spacing: 12) {
                    particleCard(who: "If you're a man",
                                 particle: "ครับ",
                                 alternate: nil,
                                 notes: "khráp · every sentence")
                    particleCard(who: "If you're a woman",
                                 particle: "ค่ะ",
                                 alternate: "/ คะ",
                                 notes: "khâ · statements\nkhá · questions")
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        case .examples:
            VStack(alignment: .leading, spacing: 16) {
                pageHeading(kicker: "examples", title: "Try them out")
                exampleCard
            }
        case .tip:
            VStack(alignment: .leading, spacing: 16) {
                pageHeading(kicker: "screen 3", title: "You've heard them")
                tip
            }
        }
    }

    /// Small accent kicker plus a big title, matching the lesson intro.
    private func pageHeading(kicker: String, title: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(kicker)
                .font(.mali(14, weight: .bold))
                .tracking(0.8)
            Text(title)
                .font(.mali(34, weight: .bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: Page indicator + Back / Next

    private var pageDots: some View {
        HStack(spacing: 8) {
            ForEach(Page.allCases) { dot in
                Capsule()
                    .fill(dot == page ? Color.lessonInk : Color.white) // fills with clr depending on whether or not this dot is current page
                    .overlay(Capsule().stroke(Color.lessonInk, lineWidth: 2))
                    .frame(width: dot == page ? 22 : 10, height: 10) //changes width if page
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.2), value: page)
    }

    private var navigationButtons: some View {
        HStack(spacing: 12) {
            if page != Page.allCases.first {
                Button { go(by: -1) } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundStyle(Color.lessonInk)
                        .frame(width: 56, height: 56)
                        .sketchCard(cornerRadius: 20)
                }
                .accessibilityLabel("Previous page")
                .transition(.move(edge: .leading).combined(with: .opacity))
            }

            Button(isLastPage ? "Continue" : "Next") {
                if isLastPage {
                    if let onFinish { onFinish() } else { dismiss() }
                } else {
                    go(by: 1)
                }
            }
            .buttonStyle(SketchPrimaryButtonStyle())
        }
        .animation(.easeInOut(duration: 0.2), value: page)
    }

    private func go(by offset: Int) {
        guard let next = Page(rawValue: page.rawValue + offset) else { return }
        withAnimation(.easeInOut(duration: 0.3)) { page = next }
    }

    // MARK: Header: close button + progress bar

    private var header: some View {
        HStack(spacing: 14) {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundStyle(Color.lessonInk)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(.white))
                    .overlay(Circle().stroke(Color.lessonInk, lineWidth: 3.5))
            }
            .accessibilityLabel("Close lesson")

            SketchRectangle(cornerRadius: 7)
                .fill(.white)
                .overlay(alignment: .leading) {
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color.lessonRose)
                            .frame(width: geo.size.width * progress)
                    }
                }
                .clipShape(SketchRectangle(cornerRadius: 7))
                .overlay {
                    SketchRectangle(cornerRadius: 7)
                        .stroke(Color.lessonInk, lineWidth: 3)
                }
                .frame(height: 14)
                .accessibilityElement()
                .accessibilityLabel("Lesson progress")
                .accessibilityValue("\(Int(progress * 100)) percent")
        }
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("politeness particles")
                .font(.mali(14, weight: .bold))
                .tracking(0.8)
            Text("ครับ and ค่ะ")
                .font(.mali(34, weight: .bold))
            Text("Thai adds a small word to the end of a sentence to sound polite. Which one you use depends on who is speaking, not who is listening.")
                .font(.mali(16))
                .lineSpacing(3)
                .foregroundStyle(Color.lessonBody)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func particleCard(who: String, particle: String, alternate: String?, notes: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(who)
                .font(.mali(13, weight: .bold))
                .foregroundStyle(Color.lessonMuted)
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(particle)
                    .font(.mali(30, weight: .bold))
                if let alternate {
                    Text(alternate)
                        .font(.mali(20, weight: .bold))
                        .foregroundStyle(Color.lessonMuted)
                }
            }
            Text(notes)
                .font(.mali(14))
                .foregroundStyle(Color.lessonMuted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .sketchCard()
    }

    // MARK: Examples

    private var exampleCard: some View {
        VStack(spacing: 0) {
            ForEach(examples) { example in
                VStack(alignment: .leading, spacing: 0) {
                    Text(example.thai)
                        .font(.mali(20, weight: .semibold))
                    Text(example.romanized)
                        .font(.mali(14))
                        .foregroundStyle(Color.lessonMuted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)

                if example.id != examples.last?.id {
                    DashedDivider()
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .sketchCard()
    }

    private var tip: some View {
        HStack(alignment: .bottom, spacing: 10) {
            CashierDog()
                .frame(width: 76, height: 62)

            Text("placeholder text, press next button to enter level")
                .font(.mali(14))
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background {
                    UnevenRoundedRectangle(topLeadingRadius: 16, bottomLeadingRadius: 4,
                                           bottomTrailingRadius: 16, topTrailingRadius: 16)
                        .fill(Color.lessonBlush)
                }
                .overlay {
                    UnevenRoundedRectangle(topLeadingRadius: 16, bottomLeadingRadius: 4,
                                           bottomTrailingRadius: 16, topTrailingRadius: 16)
                        .stroke(Color.lessonInk, lineWidth: 3)
                }
        }
    }
}

#Preview {
    Lesson1View()
}
