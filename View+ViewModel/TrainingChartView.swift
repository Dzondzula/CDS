//
//  TrainingChartView.swift
//  MyFirebase
//
//  Created by Nikola Andrijašević on 23.12.23..
//

import Foundation
import UIKit

class TrainingChartView: UIView {

    lazy var trainingProgress: TrainingProgress = {
        let view = TrainingProgress()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var trainingPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var trainingPriceQuantitiy: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

//    override var intrinsicContentSize: CGSize {
//        CGSize(width: 300, height: 300)
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        trainingProgress = self.loadViewFromNib(nibName: "TrainingProgress")! as! TrainingProgress
        constraint()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func constraint() {
        addSubview(trainingProgress)
        addSubview(trainingPriceLabel)
        addSubview(trainingPriceQuantitiy)
        trainingProgress.center = self.center
        
        NSLayoutConstraint.activate([
            trainingProgress.topAnchor.constraint(equalTo: self.topAnchor),
            trainingProgress.widthAnchor.constraint(equalTo: self.widthAnchor),
            trainingProgress.heightAnchor.constraint(equalToConstant: 200),
            trainingProgress.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            trainingPriceLabel.topAnchor.constraint(equalTo: trainingProgress.bottomAnchor, constant: 10),
            trainingPriceLabel.leadingAnchor.constraint(equalTo: trainingProgress.leadingAnchor),
            trainingPriceQuantitiy.topAnchor.constraint(equalTo: trainingProgress.bottomAnchor, constant: 10),
            trainingPriceQuantitiy.leadingAnchor.constraint(equalTo: trainingPriceLabel.trailingAnchor)
        ])
    }

    func configure() {
        trainingPriceLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        trainingPriceLabel.text = "Training price: "
        trainingPriceLabel.textColor = .gray
       // trainingPriceLabel.backgroundColor = .green

        trainingPriceQuantitiy.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        trainingPriceQuantitiy.text = "Nije placeno"
        trainingPriceQuantitiy.textColor = .gray
        //trainingPriceQuantitiy.backgroundColor = .yellow

        trainingProgress.label.text = "3/31"
        trainingProgress.label.textColor = .gray
        trainingProgress.clipsToBounds = true
       // trainingProgress.monthlyEnteryLabel.textColor = .gray
       // self.backgroundColor = .purple
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//self.resizeToFitSubviews()
      //  self.layoutIfNeeded()
    }
}

extension UIView {

    func resizeToFitSubviews() {

        let subviewsRect = subviews.reduce(CGRect.zero) {
            $0.union($1.frame)
        }

        let fix = subviewsRect.origin
        subviews.forEach {
            $0.frame.offsetBy(dx: -fix.x, dy: -fix.y)
        }

        frame.offsetBy(dx: fix.x, dy: fix.y)
        frame.size = subviewsRect.size
    }
}
