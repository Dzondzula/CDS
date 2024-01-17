import UIKit


class SubCustomCell: UICollectionViewCell {

    func onEditMode(isActive: Bool) {
        selectLabel.isHidden = !isActive
        isEditModeActive = isActive
    }
    
    var isEditModeActive = false

    override func prepareForReuse() {
        selectLabel.isHidden = !isEditModeActive
    }
    var training: TrainingInfo? {
           didSet {
            guard let training = self.training else {return}
            self.ImageView.image = UIImage(named: training.image)
               self.detailsLabel.text = "\(training.title)\n\(training.time)"
           }
       }

    func addGradient(view: UIImageView) {
        let maskedView = UIView(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
        maskedView.backgroundColor = .black
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = maskedView.bounds

        gradientMaskLayer.colors = [UIColor.black.withAlphaComponent(0.9).cgColor, UIColor.black.withAlphaComponent(0.9).cgColor, UIColor.black.withAlphaComponent(0.1).cgColor]
        gradientMaskLayer.locations = [0.1, 0.2, 0.5]
        gradientMaskLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientMaskLayer.endPoint = CGPoint(x: 0.0, y: 0.0)

        maskedView.layer.mask = gradientMaskLayer
        view.addSubview(maskedView)
    }

    var selectLabel: UILabel = {
        var selectLabel = UILabel()
        selectLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        selectLabel.layer.cornerRadius = 15
        selectLabel.layer.masksToBounds = true
        selectLabel.layer.borderColor = UIColor.white.cgColor
        selectLabel.layer.borderWidth = 1.0
        selectLabel.backgroundColor =
        UIColor.black.withAlphaComponent(0.5)

        return selectLabel
    }()

    let ImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "image1")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        return iv
    }()

    let detailsLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = "Evening Music"
        lb.numberOfLines = 3

        return lb
    }()

        override init(frame: CGRect) {
        super.init(frame: frame)
            addSubview(ImageView)

            ImageView.translatesAutoresizingMaskIntoConstraints = false
            ImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            ImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            ImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            ImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            ImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
            addGradient(view: ImageView)
            ImageView.addSubview(detailsLabel)
            ImageView.addSubview(selectLabel)


            selectLabel.translatesAutoresizingMaskIntoConstraints = false
            selectLabel.trailingAnchor.constraint(equalTo: ImageView.trailingAnchor, constant: -10).isActive = true
            selectLabel.topAnchor.constraint(equalTo: ImageView.topAnchor, constant: 10).isActive = true
            selectLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
            selectLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            selectLabel.isHidden = true
            detailsLabel.translatesAutoresizingMaskIntoConstraints = false
            detailsLabel.bottomAnchor.constraint(equalTo: ImageView.bottomAnchor, constant: -10).isActive = true
            detailsLabel.leftAnchor.constraint(equalTo: ImageView.leftAnchor, constant: 10).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
