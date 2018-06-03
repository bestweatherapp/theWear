//
//  FirstPage.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 03.06.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class FirstPage: UICollectionViewCell {
    
    private let text: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.numberOfLines = 2
        text.sizeToFit()
        text.attributedText = NSAttributedString(string: "Welcome to\ntheWear", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 30)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
        return text
    }()
    
    private let additionText: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.numberOfLines = 5
        text.sizeToFit()
        return text
    }()
    
    private let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 80).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let image: UIImageView = {
        let image = UIImageView(image: UIImage(named: "back1"))
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        LayOut()
    }
    
    func LayOut() {
        addSubview(popUpView)
        [image, text, additionText].forEach {popUpView.addSubview($0)}
        
        var fontOfAdditionText: CGFloat = 0
        var imageSize: CGFloat = 0
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5")
        case 1334:
            fontOfAdditionText = 14
            imageSize = 100
        case 2208:
            fontOfAdditionText = 14
            imageSize = 120
        case 2436:
            print("iPhone X")
        default:
            return
        }
        
        additionText.attributedText = NSAttributedString(string: "This is a weather application that not only\n shows the weather, but also helps you\n with what clothes to wear better\n today, notifies about changes\n in weather and much more", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: fontOfAdditionText)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
        popUpView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 120, left: 50, bottom: 120, right: 50), size: .init())
        image.anchor(top: popUpView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width: imageSize, height: imageSize))
        image.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        text.anchor(top: image.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 25, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        text.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        
        additionText.anchor(top: text.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        additionText.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

