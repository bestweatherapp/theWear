//
//  SecondPage.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 03.06.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class SecondPage: UICollectionViewCell {
    
    private let text: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.numberOfLines = 2
        text.sizeToFit()
        text.attributedText = NSAttributedString(string: "Let's setup a few things", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 20)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
        return text
    }()
    
    private let additionalText: UILabel = {
        let text = UILabel()
        text.sizeToFit()
        text.textAlignment = .center
        text.numberOfLines = 3
        return text
    }()
    
    private let image: UIImageView = {
        let image = UIImageView(image: UIImage(named: "back"))
        return image
    }()
    
    private let chooseGender: UILabel = {
        let text = UILabel()
        text.sizeToFit()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Who are you?", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 14)!, NSAttributedStringKey.foregroundColor:UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 80)])
        return text
    }()
    
    @objc func chooseMan(_ sender: UIButton!) {
        if UserDefaults.standard.string(forKey: "Gender") == "Man" { } else {
            UIView.animate(withDuration: 0.3, animations: {
                sender.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
                self.womanGender.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 16)
                self.layoutIfNeeded()
            })
            UserDefaults.standard.setValue("Man", forKey: "Gender")
        }
        if UserDefaults.standard.string(forKey: "Gender") == nil {
            UserDefaults.standard.setValue("Man", forKey: "Gender")
        }
    }
    @objc func chooseWoman(_ sender: UIButton!) {
        if UserDefaults.standard.string(forKey: "Gender") == "Woman" { } else {
                UIView.animate(withDuration: 0.3, animations: {
                    sender.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 17)
                    self.manGender.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 16)
                    self.layoutIfNeeded()
                })
            UserDefaults.standard.setValue("Woman", forKey: "Gender")
        }
        if UserDefaults.standard.string(forKey: "Gender") == nil {
            UserDefaults.standard.setValue("Woman", forKey: "Gender")
        }
    }
    
    private let chooseGrimy: UILabel = {
        let text = UILabel()
        text.sizeToFit()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "How grimy you are?", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 14)!, NSAttributedStringKey.foregroundColor:UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 80)])
        return text
    }()
    
    private let emojiState: UILabel = {
        let emoji = UILabel()
        emoji.textAlignment = .center
        emoji.font = UIFont(name: "SFProDisplay-Light", size: 35)
        emoji.text = "😀"
        return emoji
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        LayOut()
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!) {
        if sender.value < 2 {
            emojiState.text = "😫"
        }
        if sender.value >= 2 && sender.value < 4 {
            emojiState.text = "😬"
        }
        if sender.value >= 4 && sender.value < 5 {
            emojiState.text = "😐"
        }
        if sender.value >= 5 && sender.value < 8 {
            emojiState.text = "😀"
        }
        if sender.value >= 8 {
            emojiState.text = "😜"
        }
    }
    
    let manGender = UIButton()
    let womanGender = UIButton()
    
    func LayOut() {
        addSubview(popUpView)
        UserDefaults.standard.set(nil, forKey: "Gender") // Then it will be reduced from there
        let grimySlider = UISlider()
        grimySlider.minimumValue = 0
        grimySlider.maximumValue = 10
        grimySlider.isContinuous = true
        grimySlider.tintColor = UIColor(red: 128/255, green: 170/255, blue: 214/255, alpha: 1)
        grimySlider.value = 5
        grimySlider.addTarget(self, action: #selector(sliderValueDidChange(_ :)), for: .valueChanged)
        
        manGender.setTitle("Man", for: .normal)
        manGender.setTitleColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80), for: .normal)
        manGender.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 16)
        manGender.addTarget(self, action: #selector(chooseMan(_ :)), for: .touchUpInside)
        
        womanGender.setTitle("Woman", for: .normal)
        womanGender.setTitleColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80), for: .normal)
        womanGender.titleLabel?.font = UIFont(name: "SFProDisplay-Light", size: 16)
        womanGender.addTarget(self, action: #selector(chooseWoman(_ :)), for: .touchUpInside)
        
        [text, chooseGender, image, manGender, womanGender, chooseGrimy, grimySlider, emojiState, additionalText].forEach {popUpView.addSubview($0)}
        
        var fontForAdditionText: CGFloat = 0
        var padding: CGFloat = 0
        var imageSize: CGFloat = 0
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5")
        case 1334:
            fontForAdditionText = 12
            padding = 6
            imageSize = 100
        case 1920:
            fontForAdditionText = 14
            imageSize = 120
            padding = 8
        case 2436:
            print("iPhone X")
        default:
            return
        }
        
        additionalText.attributedText = NSAttributedString(string: "Our application is aimed at the user,\n so for more effective use of the application we \nwould like to know you", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: fontForAdditionText)!, NSAttributedStringKey.foregroundColor:UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 100)])
        image.anchor(top: popUpView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width: imageSize, height: imageSize))
        image.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        popUpView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 120, left: 50, bottom: 120, right: 50), size: .init())
        
        text.anchor(top: image.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 25, left: 0, bottom: 0, right: 0), size: .init())
        text.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        additionalText.anchor(top: text.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: padding, left: 0, bottom: 0, right: 0), size: .init())
        additionalText.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        
        chooseGender.anchor(top: additionalText.bottomAnchor, leading: popUpView.leadingAnchor, bottom: nil, trailing: popUpView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init())
        manGender.anchor(top: chooseGender.bottomAnchor, leading: popUpView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 70, bottom: 0, right: 0), size: .init(width: 70, height: 30))
        womanGender.anchor(top: chooseGender.bottomAnchor, leading: nil, bottom: nil, trailing: popUpView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 70), size: .init(width: 70, height: 30))
        chooseGrimy.anchor(top: manGender.bottomAnchor, leading: popUpView.leadingAnchor, bottom: nil, trailing: popUpView.trailingAnchor, padding: .init(top: padding, left: 0, bottom: 0, right: 0), size: .init())
        grimySlider.anchor(top: chooseGrimy.bottomAnchor, leading: popUpView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: padding, left: 100, bottom: 0, right: 0), size: .init(width: 60, height: 40))
        emojiState.anchor(top: chooseGrimy.bottomAnchor, leading: grimySlider.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: padding, left: 6, bottom: 0, right: 0), size: .init())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
