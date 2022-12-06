//
//  SubCustomCell.swift
//  spotifyAutoLayout
//
//  Created by admin on 12/3/19.
//  Copyright © 2019 Said Hayani. All rights reserved.
//



import UIKit

class SubCustomCell: UICollectionViewCell {
    var training : TrainingInfo? {
           didSet{
              // print("Playlist 🎯",self.playlist)
            guard let training = self.training else {return}
            self.ImageView.image = UIImage(named: training.image)
               self.TitleLabel.text = "\(training.title) \n \(training.time)"
               
           }
       }
    
    let ImageView : UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .yellow
        iv.image = UIImage(named: "image1")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
      
        return iv
        
    }()
    let TitleLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.text = "Evening Music"
        lb.numberOfLines = 3
        
     
        return lb
    }()
//    let DescriptionLabel : UILabel = {
//        let lb = UILabel()
//        lb.textColor = UIColor(red: 238, green: 238, blue: 238, alpha: 238)
//        lb.font = UIFont.systemFont(ofSize: 14)
//        lb.font = UIFont.boldSystemFont(ofSize: 14)
//        lb.text = "Ed Sheeran, Justin Bieber, DJ Khalid ..."
//
//        return lb
//    }()

        override init(frame: CGRect) {
        super.init(frame: frame)
            addSubview(ImageView)
            addSubview(TitleLabel)
          
           
            ImageView.translatesAutoresizingMaskIntoConstraints = false
            ImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            ImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            ImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
           // ImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            ImageView.bottomAnchor.constraint(equalTo: TitleLabel.topAnchor,constant: -15).isActive = true
            
           
           
            TitleLabel.translatesAutoresizingMaskIntoConstraints = false
            TitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 20).isActive = true
            TitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
            TitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
            
            
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
