import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
        sportLabel.clipsToBounds = true
        
        
        deleteButton.clipsToBounds = true
        sportLabel.textAlignment = .center
        
        contentView.addSubview(sportLabel)
        contentView.addSubview(deleteButton)
        
        
        NSLayoutConstraint.activate([
            sportLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            sportLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sportLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: sportLabel.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            
        ])
    }
   
    
    lazy var sportLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var deleteButton : CustomButton = {
        let button = CustomButton()
        button.setImage(UIImage(systemName: "trash.circle.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 255/255, green: 70/255, blue: 60/255, alpha: 1)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        sportLabel.text = nil
    }
    
    

}
class CustomButton: UIButton {
    var section: Int = 0
    var row : Int = 0
}
