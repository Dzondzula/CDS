//
//  MemberInfoSwiftUIView.swift
//  MyFirebase
//
//  Created by Nikola Andrijašević on 3.12.23..
//

import SwiftUI

typealias DetailsSectionList = CaseIterable & Identifiable

protocol DetailsSectionListBuilder: DetailsSectionList {
    associatedtype ContentView: View

    var title: String { get }
    var options: String { get }
    func returnView(data: String) -> ContentView
    static func getAllCases<T: CaseIterable>(_ enumType: T.Type) -> [T]
}

enum MemberInfoProperties: DetailsSectionListBuilder {
    var id: Self { self }

    case trainingChart
    case sports

    var title: String {
        switch self {
            case .trainingChart:
                "Training"
            case .sports:
                "Sport"
        }
    }

    var options: String {
        switch self {
            case .trainingChart:
                "Show History"
            case .sports:
                "None"
        }
    }

    @ViewBuilder func returnView(data: String) -> some View {
        switch self {
            case .trainingChart:
                DetailsSectionView { TrainingChartViewRepresented()
                }
                .frame(minHeight: 250, maxHeight: 300)
            case .sports:
                TagView()
        }
    }

    static func getAllCases<T>(_ enumType: T.Type) -> [T] where T: CaseIterable {
        return Array(T.allCases)
    }
}

struct DetailsSectionViews<Builder: DetailsSectionListBuilder>: View {
    let data: String
    // let function: () -> Void

    var body: some View {
        List(Builder.getAllCases(Builder.self), id: \.id) { content in
            Section {
                content.returnView(data: data)
                // .frame(maxWidth: .infinity, alignment: .center)
            } header: {
                HStack {
                    Text(content.title)
                        .font(.title).bold()
                    Spacer()
                    Text(content.options).fontWeight(.regular).foregroundStyle(.blue)
                }
            }
            .headerProminence(.increased)
        }
    }
}

#Preview {
    DetailsSectionViews<MemberInfoProperties>(data: "Lorem ipsum")
}

struct DetailsSectionView<Content: View>: View {
    var content: () -> Content

    init(content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
    }
}

//extension UIWindow {
//    static var current: UIWindow? {
//        for scene in UIApplication.shared.connectedScenes {
//            guard let windowScene = scene as? UIWindowScene else { continue }
//            for window in windowScene.windows
//            where window.isKeyWindow { return window }
//        }
//        return nil
//    }
//}
//
//
//extension UIScreen {
//    static var current: UIScreen? {
//        UIWindow.current?.screen
//    }
//}

struct TagTrainingButton: View {
    var data: String
    var body: some View {
        HStack(spacing: 0) {
            Text(data)
                .frame(height: 40)
                .padding(.trailing, 5)
                .padding(.leading, 10)
            Button {
                // Add Action
            } label: {
                Image(systemName: "trash")
                    .frame(width: 40, height: 35)

                    .foregroundStyle(.white)
                    .background(.red)
            }
            .clipShape(.circle)
        }
        .background(Color(UIColor.opaqueSeparator))
        .clipShape(.capsule)
    }
}

struct TagView: View {
    var body: some View {
        let trainingString: [String] = ["Select training", "KMG", "Wrestling", "Bjj", "KickBox", "MMA", "Box"].sorted { $0.count < $1.count }

        CustomTagView(alignment: .leading, spacing: 9) {
            ForEach(trainingString, id: \.self) { tr in
                TagTrainingButton(data: tr)
            }
        }
    }
}

struct CustomTagView: Layout {

    var alignment: Alignment = .leading
    var spacing: CGFloat = 10

    init(alignment: Alignment, spacing: CGFloat) {
        self.alignment = alignment
        self.spacing = spacing
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        let rows = generateRows(maxWidth, proposal, subviews)

        for(index, row) in rows.enumerated() {
            /// Finding max Height in each row and adding it to the View's Total Height
            if index == (rows.count - 1) {
                height += row.maxHeight(proposal)
            } else {
                height += row.maxHeight(proposal) + spacing
            }
        }
        return .init(width: maxWidth, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        let maxWidth = bounds.width
        let rows = generateRows(maxWidth, proposal, subviews)

        for row in rows {
            // Chaning Origin X based on Alignment
            let leading: CGFloat = bounds.maxX - maxWidth
            let trailing = bounds.maxX - (row.reduce(CGFloat.zero) { partialResult, view in
                let width = view.sizeThatFits(proposal).width

                if view == row.last {
                    // No spacing
                    return partialResult + width
                }
                // With Spacing
                return partialResult + width + spacing
            })
            let center = (trailing + leading) / 2
            /// Reseting Origin X to Zero For Each Row
            origin.x = (alignment == .leading ? leading : alignment == .trailing ? trailing : center)

            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                /// Updating Origin X
                origin.x += (viewSize.width + spacing)
            }

            /// Updating Origin Y
            origin.y += (row.maxHeight(proposal) + spacing)
        }
    }


    func generateRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subviews: Subviews) -> [[LayoutSubviews.Element]] {

        var row: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []

        /// Origin
        var origin = CGRect.zero.origin

        for view in subviews {
            let viewSize = view.sizeThatFits(proposal)

            /// Pushing to new row
            if(origin.x + viewSize.width + spacing) > maxWidth {
                rows.append(row)
                row.removeAll()
                /// Reseting X Origin since it needs to start from left to right
                origin.x = 0
                row.append(view)
                /// Updating Origin X
                origin.x += (viewSize.width + spacing)

            } else {
                /// adding item to same row
                row.append(view)
                /// Updating Origin X
                origin.x += (viewSize.width + spacing)
            }
        }

        if !row.isEmpty {
            rows.append(row)
            row.removeAll()
        }

        return rows
    }
}

extension [LayoutSubviews.Element] {
    func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
        return self.compactMap { view in
            return view.sizeThatFits(proposal).height
        }.max() ?? 0
    }
}
