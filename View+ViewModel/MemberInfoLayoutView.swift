//
//  MemberInfoLayoutView.swift
//  MyFirebase
//
//  Created by Nikola Andrijašević on 3.4.23..
//

import UIKit

class MemberInfoLayoutView: UIView {

    lazy var collectionView = UICollectionView()
    let paymentView = UIView()
    let nameLabel = UILabel()
    let profilePicture = UIImageView()
    let containerView = UIView()
    let trainings = UIButton()
    let paymentViewTitle = UILabel()
    let trainingPriceLabel = UILabel()
    let paymentStatusPicture = UIImageView()
    let paymentStatusLabel = UILabel()


    override init(frame: CGRect) {
        super.init(frame: frame)

        let layout = TagFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)


        configure()
        constraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    private func constraint() {
        addConstrainedSubviews(containerView, paymentView, collectionView)
        paymentView.addSubview(paymentViewTitle)
        paymentView.addSubview(paymentStatusPicture)
        paymentView.addSubview(paymentStatusLabel)
        paymentView.addSubview(trainingPriceLabel)
        containerView.addSubview(profilePicture)
        containerView.addSubview(trainings)
        containerView.addSubview(nameLabel)


        paymentStatusPicture.translatesAutoresizingMaskIntoConstraints = false
        paymentViewTitle.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        paymentStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        trainingPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        trainings.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 3),

            paymentView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 15),
            paymentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            paymentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            paymentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 3),

            collectionView.topAnchor.constraint(equalTo: paymentView.bottomAnchor, constant: 15),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 4),
            profilePicture.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            profilePicture.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profilePicture.widthAnchor.constraint(equalToConstant: 120),
            profilePicture.heightAnchor.constraint(equalToConstant: 120),
            trainings.bottomAnchor.constraint(equalTo: profilePicture.topAnchor),
            trainings.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            trainings.heightAnchor.constraint(equalToConstant: 30),

            nameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            paymentViewTitle.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 20),
            paymentViewTitle.leftAnchor.constraint(equalTo: paymentView.leftAnchor, constant: 10),

            trainingPriceLabel.centerYAnchor.constraint(equalTo: paymentView.centerYAnchor),
            trainingPriceLabel.leftAnchor.constraint(equalTo: paymentView.leftAnchor, constant: 30),

            paymentStatusPicture.centerYAnchor.constraint(equalTo: paymentView.centerYAnchor),
            paymentStatusPicture.rightAnchor.constraint(equalTo: paymentView.rightAnchor, constant: -20),
            paymentStatusPicture.widthAnchor.constraint(equalToConstant: 120),
            paymentStatusPicture.heightAnchor.constraint(equalToConstant: 120),

            paymentStatusLabel.topAnchor.constraint(equalTo: paymentStatusPicture.bottomAnchor, constant: 10),
            paymentStatusLabel.rightAnchor.constraint(equalTo: paymentView.rightAnchor, constant: -10)
        ])
    }

    func configure() {


        
        collectionView.layer.cornerRadius = 13.0
        collectionView.layer.masksToBounds = true
        collectionView.backgroundColor = .black

        containerView.backgroundColor = .black
        containerView.layer.cornerRadius = 8.0
        containerView.layer.masksToBounds = true

        profilePicture.isUserInteractionEnabled = true
        profilePicture.layer.cornerRadius = 120 / 2
        profilePicture.backgroundColor = .brown
        profilePicture.image = UIImage(named: "CDS")
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)


        nameLabel.text = "Car Dušan Silni"
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.isUserInteractionEnabled = true

        paymentView.layer.cornerRadius = 13.0
        paymentView.layer.masksToBounds = true
        paymentView.layer.shadowRadius = 7.0
        paymentView.layer.masksToBounds = false
        paymentView.layer.shadowColor = UIColor.black.cgColor
        paymentView.layer.shadowOpacity = 0.10
        // How far the shadow is offset from the UICollectionViewCell’s frame
        paymentView.layer.shadowOffset = CGSize(width: 0, height: 5)
        paymentView.backgroundColor = .black

        paymentStatusPicture.image = UIImage(named: "unpaid")
        paymentStatusPicture.contentMode = .scaleAspectFill
        paymentStatusPicture.clipsToBounds = true

        paymentStatusPicture.isUserInteractionEnabled = true


        paymentViewTitle.text = "Training status"
        paymentViewTitle.textColor = .white
        paymentViewTitle.font = UIFont.systemFont(ofSize: 28, weight: .semibold)


        paymentStatusLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)

        paymentStatusLabel.text = "Nije placeno"
        paymentStatusLabel.textColor = .white


        trainingPriceLabel.font = UIFont(name: "Avenir", size: 30)
        trainingPriceLabel.text = "00,00"
        trainingPriceLabel.textAlignment = .justified
        trainingPriceLabel.textColor = .white

        trainings.setTitle("Change training", for: .normal)
    }
}


extension UIView {
    func addConstrainedSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }

    func addConstrainedSubviews(_ views: UIView...) {
        views.forEach { view in addConstrainedSubview(view) }
    }
}
