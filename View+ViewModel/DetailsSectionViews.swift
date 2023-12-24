//
//  MemberInfoSwiftUIView.swift
//  MyFirebase
//
//  Created by Nikola Andrijašević on 3.12.23..
//

import SwiftUI
enum MemberInfoProperties: Identifiable,CaseIterable, View{

    var id: Self {
        return self
    }
//    var id: String {
//        switch self {
//            case .trainingChart(let data), .sports(let data):
//                return data!
//        }
//    }
//    static var allCases: [MemberInfoProperties] = [MemberInfoProperties(data: "KK")]


//    init(data: String) {
//        if data.count > 3{  self = .sports(data: data)}
//        else {self = .trainingChart(data: data)}
//    }


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

    @ViewBuilder
    var body: some View {
        switch self {
        case .trainingChart:
                DetailsSectionView(title: self.title, options: self.options) { TrainingProgressViewRepresented()
                }
        case .sports:
                Text("SKR")
        }
    }
}
struct DetailsSectionViews: View {
    let string: String
    var body: some View {
        List(MemberInfoProperties.allCases) { content in
                Section {
                    content
                } header: {
                    HStack {
                        Text(content.title)
                            .font(.title).bold()
                        Spacer()
                        Text(content.options).fontWeight(.light).foregroundStyle(.blue)
                    }
                }
                .headerProminence(.increased)
        }
    }
}

#Preview {
    DetailsSectionViews(string: "k")
}

struct DetailsSectionView<Content: View>: View, Identifiable {
    var id: UUID = UUID()

    let title: String
    let options: String
    @ViewBuilder var content: () -> Content

    init(title: String, options: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.options = options
        self.content = content
    }

    var body: some View {
       content()
    }
}
