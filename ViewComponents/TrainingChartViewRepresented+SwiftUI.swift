//
//  TrainingChartViewRepresented+SwiftUI.swift
//  MyFirebase
//
//  Created by Nikola Andrijašević on 3.12.23..
//

import Foundation
import SwiftUI

struct TrainingChartViewRepresented: UIViewRepresentable {

    func makeUIView(context: Context) -> TrainingChartView {
        let training = TrainingChartView()
        return training
    }

    func updateUIView(_ uiView: TrainingChartView, context: Context) {
        //
    }
}

struct TagTrainingViewRepresented: UIViewRepresentable {

    func makeUIView(context: Context) -> UICollectionView {
        let layout = TagFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.id)

        return tagCollectionView
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        //
    }
}
