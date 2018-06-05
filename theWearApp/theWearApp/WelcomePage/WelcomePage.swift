//
//  WelcomePage.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 23.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

extension UIColor {
    static var dark = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)
    static var lightBlue = UIColor(red: 124/255, green: 214/255, blue: 255/255, alpha: 1)
    static var myGray = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 100)
}
class WelcomePage: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let backgroundImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "BlurDefaultBackground"))
        return image
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 3
        pc.currentPageIndicatorTintColor = .dark
        pc.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.9)
        return pc
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.dark, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.dark, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        previousButton.setTitle("Back", for: .normal)
        let nextIndex = min(pageControl.currentPage + 1, 2)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        if indexPath.item == 2 {
            nextButton.setTitle("Start", for: .normal)
        } else {
           nextButton.setTitle("Next", for: .normal)
        }
        if pageControl.currentPage == indexPath.item {
//            After that WelcomePage will be closed and will never appear again
//            UserDefaults.standard.set(true, forKey: "firstTimeOpened")
//            let mainVC = ViewController()
//            present(mainVC, animated: true, completion: nil)
        }
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        if indexPath.item == 0 {
            previousButton.setTitle("", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.distribution = .fillEqually
        view.addSubview(bottomControlsStackView)
        bottomControlsStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        previousButton.setTitle("Back", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundView = backgroundImageView
        collectionView?.register(FirstPage.self, forCellWithReuseIdentifier: "FirstPage")
        collectionView?.register(SecondPage.self, forCellWithReuseIdentifier: "SecondPage")
        collectionView?.register(ThirdPage.self, forCellWithReuseIdentifier: "ThirdPage")
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        setupBottomControls()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstPage", for: indexPath) as! FirstPage
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondPage", for: indexPath) as! SecondPage
            return cell
        } else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThirdPage", for: indexPath) as! ThirdPage
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "FirstPage", for: indexPath) as! FirstPage
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
