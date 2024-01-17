import UIKit

protocol SportTagCollectionHandler: UICollectionViewCell {
    static var id: String { get }
}

class TagCollectionViewCell: UICollectionViewCell, SportTagCollectionHandler {

    static let id = "memberTrainingCell"
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 18.0
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
        label.backgroundColor = UIColor.systemGray5
        label.textColor = .darkText
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var deleteButton: CustomButton = {
        let button = CustomButton()
        button.setImage(UIImage(systemName: "trash.circle.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed

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
    var row: Int = 0
}

class UserTagCollectionViewCell: UICollectionViewCell, SportTagCollectionHandler {
static let id = "trainingCell"
    override init(frame: CGRect) {

        super.init(frame: frame)

        self.backgroundColor = .black
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
        sportLabel.clipsToBounds = true

        sportLabel.textAlignment = .center
        contentView.addSubview(sportLabel)

        NSLayoutConstraint.activate([
            sportLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            sportLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sportLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sportLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    lazy var sportLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 180 / 255, green: 180 / 255, blue: 180 / 255, alpha: 0.9)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        sportLabel.text = nil
    }
}

protocol TagCellHandeler {
    var type: CoordinatorType { get }
    func collectionView(type: CoordinatorType,
                        _ sport: String,
                        _ collectionView: UICollectionView,
                        cellForRowAt indexPath: IndexPath) -> UICollectionViewCell
}

class TagContainer {
    var tagHandlers: [CoordinatorType: TagCellHandeler] = [:]
    init(handlers: [TagCellHandeler]) {
        handlers.forEach { handler in
            tagHandlers[handler.type] = handler
        }
    }

    func collectionView(type: CoordinatorType,
                        _ sport: String,
                        _ collectionView: UICollectionView,
                        cellForRowAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tagHandler = tagHandlers[type] else {return UICollectionViewCell()}
        return tagHandler.collectionView(type: type, sport, collectionView, cellForRowAt: indexPath)
    }
}

class UserTagHandler: TagCellHandeler {
    var type: CoordinatorType {
        return CoordinatorType.user
    }

    func collectionView(type: CoordinatorType, _ sport: String, _ collectionView: UICollectionView, cellForRowAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserTagCollectionViewCell.id, for: indexPath) as? UserTagCollectionViewCell else {return UICollectionViewCell()}
        userCell.sportLabel.text = sport
        
        return userCell
    }
}

class MemberTagHandler: TagCellHandeler {
    var type: CoordinatorType = .member

    func collectionView(type: CoordinatorType, _ sport: String, _ collectionView: UICollectionView, cellForRowAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let memberCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.id, for: indexPath) as? TagCollectionViewCell else {return UICollectionViewCell()}
        memberCell.sportLabel.text = sport
        memberCell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        return memberCell
    }
}
