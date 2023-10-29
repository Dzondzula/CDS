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
    let changeTraining = UIButton()
    let changeSubscription = UIButton()
    let paymentViewTitle = UILabel()
    let stackView = UIStackView()
    let trainingPriceLabel = UILabel()
    let paymentStatusPicture = UIImageView()
    let subscriptionStatusLabel = UILabel()


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
        stackView.addArrangedSubview(changeTraining)
        stackView.addArrangedSubview(changeSubscription)
        paymentView.addSubview(paymentViewTitle)
        paymentView.addSubview(paymentStatusPicture)
        paymentView.addSubview(trainingPriceLabel)
        containerView.addSubview(profilePicture)
        containerView.addSubview(nameLabel)
        containerView.addSubview(subscriptionStatusLabel)
        containerView.addSubview(stackView)
        addConstrainedSubviews(containerView, paymentView, collectionView)


        changeTraining.translatesAutoresizingMaskIntoConstraints = false
        changeSubscription.translatesAutoresizingMaskIntoConstraints = false
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
            profilePicture.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            profilePicture.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profilePicture.widthAnchor.constraint(equalToConstant: 120),
            profilePicture.heightAnchor.constraint(equalToConstant: 120),
            stackView.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: profilePicture.topAnchor),

            paymentViewTitle.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 20),
            paymentViewTitle.leftAnchor.constraint(equalTo: paymentView.leftAnchor, constant: 10),

            trainingPriceLabel.centerYAnchor.constraint(equalTo: paymentView.centerYAnchor),
            trainingPriceLabel.leftAnchor.constraint(equalTo: paymentView.leftAnchor, constant: 30),

            paymentStatusPicture.centerYAnchor.constraint(equalTo: paymentView.centerYAnchor),
            paymentStatusPicture.rightAnchor.constraint(equalTo: paymentView.rightAnchor, constant: -20),
            paymentStatusPicture.widthAnchor.constraint(equalToConstant: 130),
            paymentStatusPicture.heightAnchor.constraint(equalToConstant: 130),

           subscriptionStatusLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 20),
            subscriptionStatusLabel.bottomAnchor.constraint(equalTo: profilePicture.bottomAnchor)
        ])
    }

    func configure() {
        self.backgroundColor = .gray
        collectionView.layer.cornerRadius = 13.0
        collectionView.layer.masksToBounds = true
        collectionView.backgroundColor = .white

        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 8.0
        containerView.layer.masksToBounds = true

        profilePicture.isUserInteractionEnabled = true
        profilePicture.layer.cornerRadius = 20
        profilePicture.backgroundColor = .brown
        profilePicture.image = UIImage(named: "CDS")
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.borderColor = UIColor.lightGray.cgColor

        nameLabel.text = "Car Dušan Silni"
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        nameLabel.textColor = .darkText
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


        subscriptionStatusLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)

        subscriptionStatusLabel.text = "Nije placeno"
        subscriptionStatusLabel.textColor = .gray


        trainingPriceLabel.font = UIFont(name: "Avenir", size: 30)
        trainingPriceLabel.text = "00,00"
        trainingPriceLabel.textAlignment = .justified
        trainingPriceLabel.textColor = .white

        var atributeContainer = AttributeContainer()
        atributeContainer.font = UIFont.boldSystemFont(ofSize: 16)

        var changeTrainingButtonConfig = UIButton.Configuration.tinted()
        changeTrainingButtonConfig.attributedTitle = AttributedString("Change training", attributes: atributeContainer)
        changeTrainingButtonConfig.cornerStyle = .capsule
        changeTrainingButtonConfig.baseBackgroundColor = .gray
        changeTrainingButtonConfig.baseForegroundColor = .darkText
        changeTraining.configuration = changeTrainingButtonConfig


        var changeSubsButtonConfig = UIButton.Configuration.filled()
        changeSubsButtonConfig.image = UIImage(systemName: "dollarsign.circle")
        changeSubsButtonConfig.attributedTitle = AttributedString("Subscription", attributes: atributeContainer)
        changeSubsButtonConfig.cornerStyle = .capsule
        changeSubsButtonConfig.baseBackgroundColor = .systemRed
        changeSubsButtonConfig.baseForegroundColor = .white
        changeSubsButtonConfig.imagePadding = 5
        changeSubscription.configuration = changeSubsButtonConfig


        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.axis = .horizontal
    }
}


extension UIView {
    func addConstrainedSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        addSubview(view)
    }

    func addConstrainedSubviews(_ views: UIView...) {
        views.forEach { view in addConstrainedSubview(view) }
    }
}

