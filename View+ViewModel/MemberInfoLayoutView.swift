//
//  MemberInfoLayoutView.swift
//  MyFirebase
//
//  Created by Nikola Andrijašević on 3.4.23..
// History
// renew subscription

import UIKit

class MemberInfoLayoutView: UIStackView {

    lazy var tagCollectionView = UICollectionView()
    let trainingChartView = TrainingChartView()
    let nameLabel = UILabel()
    let profilePicture = UIImageView()
    let detailsContainerView = UIView()
    let changeTraining = UIButton()
    let changeSubscription = UIButton()
    let paymentViewTitle = UILabel()
    let stackView = UIStackView()
  //  let trainingPriceLabel = UILabel()
    //let trainingPriceQuantitiy = UILabel()
    let paymentStatusPicture = UIImageView()
    let subscriptionStatusLabel = UILabel()
    let sportsLabel = UILabel()
    let goToTrainingSchedule = UIButton()
    //var trainingProgress = TrainingProgress()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.distribution = .fillProportionally
        self.spacing = 20
        self.alignment = .center
        self.axis = .vertical
        self.backgroundColor = .black
        let layout = TagFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       // trainingProgress = self.loadViewFromNib(nibName: "TrainingProgress")! as! TrainingProgress
        constraint()
        configure()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func constraint() {
        stackView.addArrangedSubview(changeTraining)
        stackView.addArrangedSubview(changeSubscription)
//        trainingChartView.addSubview(trainingProgress)
//        trainingChartView.addSubview(trainingPriceLabel)
//        trainingChartView.addSubview(trainingPriceQuantitiy)
        detailsContainerView.addSubview(profilePicture)
        detailsContainerView.addSubview(nameLabel)
        detailsContainerView.addSubview(subscriptionStatusLabel)
        detailsContainerView.addSubview(stackView)
        addConstrainedSubviews(detailsContainerView, trainingChartView, tagCollectionView)

        changeTraining.translatesAutoresizingMaskIntoConstraints = false
        changeSubscription.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
          //  detailsContainerView.topAnchor.constraint(equalTo: topAnchor),
            detailsContainerView.leftAnchor.constraint(equalTo: leftAnchor),
            detailsContainerView.rightAnchor.constraint(equalTo: rightAnchor),
            detailsContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 3),


           // trainingChartView.topAnchor.constraint(equalTo: detailsContainerView.bottomAnchor, constant: 10),
            trainingChartView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            trainingChartView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
           trainingChartView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 3),

           // tagCollectionView.topAnchor.constraint(equalTo: trainingChartView.bottomAnchor, constant: 5),
            tagCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            tagCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
           // tagCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),


            profilePicture.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor, constant: 15),
            profilePicture.centerYAnchor.constraint(equalTo: detailsContainerView.centerYAnchor),
            profilePicture.widthAnchor.constraint(equalToConstant: 120),
            profilePicture.heightAnchor.constraint(equalToConstant: 120),
            stackView.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: detailsContainerView.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: profilePicture.topAnchor),
            subscriptionStatusLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 20),
            subscriptionStatusLabel.bottomAnchor.constraint(equalTo: profilePicture.bottomAnchor),

        ])
    }

    func configure() {
       // self.backgroundColor = UIColor.opaqueSeparator
        tagCollectionView.layer.cornerRadius = 8.0
        tagCollectionView.layer.masksToBounds = true
        tagCollectionView.backgroundColor = .systemBackground

        detailsContainerView.backgroundColor = .systemBackground

        trainingChartView.layer.cornerRadius = 8.0
        trainingChartView.layer.masksToBounds = true
        trainingChartView.backgroundColor = .systemBackground

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

//        trainingPriceLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
//        trainingPriceLabel.text = "Training price: "
//        trainingPriceLabel.textColor = .gray
//
//        trainingPriceQuantitiy.font = UIFont.systemFont(ofSize: 18, weight: .regular)
//        trainingPriceQuantitiy.text = "Nije placeno"
//        trainingPriceQuantitiy.textColor = .gray
//
//        trainingProgress.label.text = "This month"
//        trainingProgress.label.textColor = .gray
//        trainingProgress.clipsToBounds = true
//        trainingProgress.monthlyEnteryLabel.textColor = .gray

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


extension UIStackView {
    func addConstrainedSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        addArrangedSubview(view)
    }

    func addConstrainedSubviews(_ views: UIView...) {
        views.forEach { view in addConstrainedSubview(view) }
    }
}

class MemberDetailsView: UIView {

    let nameLabel = UILabel()
    let profilePicture = UIImageView()
    let changeTraining = UIButton()
    let changeSubscription = UIButton()
    let paymentViewTitle = UILabel()
    let stackView = UIStackView()
    let subscriptionStatusLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        constraint()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraint() {
        self.translatesAutoresizingMaskIntoConstraints = false
        changeTraining.translatesAutoresizingMaskIntoConstraints = false
        changeSubscription.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(changeTraining)
        stackView.addArrangedSubview(changeSubscription)

        addTamicSubviews(profilePicture, nameLabel, subscriptionStatusLabel, stackView)

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topAnchor),
            self.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 3),

            profilePicture.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            profilePicture.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            profilePicture.widthAnchor.constraint(equalToConstant: 120),
            profilePicture.heightAnchor.constraint(equalToConstant: 120),
            stackView.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: profilePicture.topAnchor),
            subscriptionStatusLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 20),
            subscriptionStatusLabel.bottomAnchor.constraint(equalTo: profilePicture.bottomAnchor)
        ])
    }

    func configure() {
        self.backgroundColor = .systemBackground
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

        paymentViewTitle.text = "Training status"
        paymentViewTitle.textColor = .white
        paymentViewTitle.font = UIFont.systemFont(ofSize: 28, weight: .semibold)


        subscriptionStatusLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        subscriptionStatusLabel.text = "Nije placeno"
        subscriptionStatusLabel.textColor = .gray

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
    func addTamicSubviews(_ subviews: UIView...) {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}

class DetailsView: UIView {
    var memberInfoView = MemberInfoSwiftUI(data: "")
    var memberDetailsView = MemberDetailsView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        constraint()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func constraint() {
        addTamicSubviews(memberInfoView,memberDetailsView)
//self.bringSubviewToFront(memberDetailsView)


        NSLayoutConstraint.activate([
            memberDetailsView.topAnchor.constraint(equalTo: topAnchor),
            memberDetailsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            memberDetailsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            memberDetailsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 3),

            memberInfoView.topAnchor.constraint(equalTo: memberDetailsView.bottomAnchor),
            memberInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            memberInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            memberInfoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(){
        self.backgroundColor = .systemBackground
        memberDetailsView.roundCorners(with: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: 10)
        memberDetailsView.addShadow(opacity: 0.3, offsetX: 0.0, offsetY: 4.0, radius: 3.0, color: UIColor.gray.cgColor)

    }
}

extension UIView {
    func roundCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [CACornerMask]
    }

    func addShadow(opacity: Float, offsetX: CGFloat, offsetY: CGFloat, radius: CGFloat, color: CGColor) {
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        self.layer.shadowRadius = radius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }
}
