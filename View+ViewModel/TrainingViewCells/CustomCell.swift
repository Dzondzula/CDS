//
//  CustomCell.swift
//  spotifyAutoLayout
//
//  Created by admin on 10/31/19.
//  Copyright © 2019 Said Hayani. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    var isEditing: Bool = true {
        didSet {
            let cell = self.nestedCollectionView.visibleCells as? [SubCustomCell]
            cell?.forEach{ $0.onEditMode(isActive: isEditing) }
        }
    }

    var section: TrainingSections? {
        didSet {
            guard let section = self.section else {return}
            self.dayTitleLabel.text = section.weekDay.description
            self.trainings = section.training
            self.nestedCollectionView.reloadData()
        }
    }

    lazy var trainings = [TrainingInfo]()

    let nestedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.collectionView?.allowsSelectionDuringEditing = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGray6
        cv.register(SubCustomCell.self, forCellWithReuseIdentifier: "subCellID")
        cv.translatesAutoresizingMaskIntoConstraints = false

        return cv
    }()

    let cellId: String = "subCellID"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.trainings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SubCustomCell
        cell.training = trainings[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = frame.height / 1.4
        let height = frame.height / 1.4

        return CGSize(width: width, height: height)
    }

    let dayTitleLabel: UILabel = {
        let lb  = UILabel()
        lb.text = "Section Title"
        lb.textColor = .darkText
        lb.font = UIFont.boldSystemFont(ofSize: 30)
        lb.translatesAutoresizingMaskIntoConstraints = false

        return lb
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dayTitleLabel)

        dayTitleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dayTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10 ).isActive = true

       setupSubCells()
        nestedCollectionView.register(SubCustomCell.self, forCellWithReuseIdentifier: cellId)
    }


    private func setupSubCells() {
        // add collectionView to the view
        addSubview(nestedCollectionView)

        nestedCollectionView.dataSource = self
        nestedCollectionView.delegate = self
        // make it fit all the space of the CustomCell
        nestedCollectionView.topAnchor.constraint(equalTo: dayTitleLabel.bottomAnchor).isActive = true
        nestedCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        nestedCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nestedCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
