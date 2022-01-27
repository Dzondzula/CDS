//
//  MemberTableViewCell.swift
//  MyFirebase
//
//  Created by Nikola Andrijasevic on 13.1.22..
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    
    func config(with item: UserInfo){
        if item.admin == false{
        if let picture = item.pictureURL,
           let url = URL(string: picture){
        profileImageView.loadImage(url: url)
        } else {
            profileImageView.image = UIImage(named: "venom")
        }
            nameLabel.text = item.firstName
            guard let trening = item.training else {return}
            trainingLabel.text = trening[0]
            
            let child = DataObjects.infoRef.child(item.uid)//add to service
            let child2 = child.child("Payments")
            child2.child("isPaid").observeSingleEvent(of: .value, with: { [self](snapshot) in
                if snapshot.exists(){
                let data = snapshot.value as! Bool
                    if data == true{
                        countryImageView.image = UIImage(named: "greenLight")
                    } else if data == false{
                        countryImageView.image = UIImage(named: "redLight")
                    }
                }
            })
    }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(trainingLabel)
        addSubview(containerView)
        self.contentView.addSubview(countryImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo:centerYAnchor), profileImageView.leadingAnchor.constraint(equalTo:leadingAnchor, constant:10),
            profileImageView.widthAnchor.constraint(equalToConstant:70), profileImageView.heightAnchor.constraint(equalToConstant:70),
            
            containerView.centerYAnchor.constraint(equalTo:centerYAnchor), containerView.leadingAnchor.constraint(equalTo:profileImageView.trailingAnchor, constant:10), containerView.trailingAnchor.constraint(equalTo:trailingAnchor, constant:-10), containerView.heightAnchor.constraint(equalToConstant:40),
           

            nameLabel.topAnchor.constraint(equalTo:containerView.topAnchor), nameLabel.leadingAnchor.constraint(equalTo:containerView.leadingAnchor), nameLabel.trailingAnchor.constraint(equalTo:containerView.trailingAnchor),
            
            trainingLabel.topAnchor.constraint(equalTo:nameLabel.bottomAnchor), trainingLabel.leadingAnchor.constraint(equalTo:containerView.leadingAnchor), trainingLabel.topAnchor.constraint(equalTo:nameLabel.bottomAnchor),
            

           countryImageView.widthAnchor.constraint(equalToConstant:26), countryImageView.heightAnchor.constraint(equalToConstant:26), countryImageView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-20), countryImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let profileImageView:UIImageView = {
             let img = UIImageView()
             img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
             img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
             img.layer.cornerRadius = 35
             img.clipsToBounds = true
            return img
         }()
    
    let countryImageView:UIImageView = {
            let img = UIImageView()
            img.contentMode = .scaleAspectFill // without this your image will shrink and looks ugly
            img.translatesAutoresizingMaskIntoConstraints = false
            img.layer.cornerRadius = 13
            img.clipsToBounds = true
            return img
        }()
    
    let containerView:UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.clipsToBounds = true // this will make sure its children do not go out of the boundary
      return view
    }()
    
    let nameLabel:UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor =  .darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    
    let trainingLabel:UILabel = {
      let label = UILabel()
      label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor =  .white
        label.backgroundColor =  .black
      label.layer.cornerRadius = 5
      label.clipsToBounds = true
      label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//
//    }

}
extension UIImageView{
    func loadImage(url : URL){
        DispatchQueue.global().async {
            [self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
            
        }
    }
}
