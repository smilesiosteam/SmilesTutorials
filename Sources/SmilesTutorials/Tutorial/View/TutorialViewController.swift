//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/06/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities
import LottieAnimationManager
import SmilesPageController

public class TutorialViewController: UIViewController {
    
    // MARK: -- Outlets
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: JXPageControlJump!
    
    @IBOutlet weak var skipToLoginButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: -- Properties
    public static let storyboardVC = UIStoryboard(name: "Tutorial", bundle: Bundle.module).instantiateInitialViewController() as! TutorialViewController
    
    private var autoScroller: CollectionViewAutoScroller!
    private var slides = [
        Slide(title: "Discover the world of smiles", subTitle: "Offerings panning from categories like food, travel, entertainment and many more. Explore the world of smiles and discover the best.", imageName: "slide1_image", animationName: ""),
        Slide(title: "Earn rewards for every spend", subTitle: "Assured rewards on every spend that you make on the app. Smiles provides the best of savings and rewards for you.", imageName: "slide2_image", animationName: ""),
        Slide(title: "Personalized suggestions", subTitle: "We at smiles personalize the offers you see based on your interests and lifestyle. Hop into a world that is tailor made for you.", imageName: "slide3_image", animationName: "")
    ]
    weak var timer: Timer?
    public var skipToLoginAction={}
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewUI()
        setupCollectionView()
        initialSetup()
    }
    
    private func setupViewUI() {
        view.backgroundColor = UIColor(red: 245.0 / 255.0, green: 247.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
        
        let underlineAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: SmilesFonts.circular.getFont(style: .medium, size: 16),
            NSAttributedString.Key.foregroundColor: UIColor.appRevampFilterCountBGColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ] // .styleDouble.rawValue, .styleThick.rawValue, .styleNone.rawValue
        
        let skipToLoginAttributedTitle = NSMutableAttributedString(
            string: "Skip to login",
            attributes: underlineAttributes
        )
        
        skipToLoginButton.setAttributedTitle(skipToLoginAttributedTitle, for: .normal)
        
        nextButton.backgroundColor = .appRevampPurpleMainColor
        nextButton.titleLabel?.font = SmilesFonts.circular.getFont(style: .medium, size: 16)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 24)
        
        bottomView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20)
    }
    
    private func initialSetup() {
        collectionView.reloadData()
        autoScroller.resetAutoScroller()
        pageController.currentIndex = 0
        autoScroller.itemsCount = slides.count
        autoScroller.startTimer(interval: getTimeInterval())
        autoScroller.scrollDidFire = { [weak self] currentIndex in
            guard let self = self else { return }
            self.setImage(at: currentIndex)
        }
        pageController.contentAlignment = JXPageControlAlignment(.left, .center)
        
        animationView.isHidden = true
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: String(describing: TextSlideCollectionViewCell.self), bundle: Bundle.module), forCellWithReuseIdentifier: String(describing: TextSlideCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = setupCollectionViewLayout()
        autoScroller = CollectionViewAutoScroller(collectionView: collectionView, itemsCount: 0, currentIndex: 0)
    }
    
    func setupCollectionViewLayout() ->  UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(94)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            
            section.visibleItemsInvalidationHandler = { [weak self] (items, offset, env) -> Void in
                guard let self = self else { return }
                let page = round(offset.x / self.collectionView.bounds.width)
                self.pageController.currentPage = Int(page)
                self.autoScroller.currentIndex = Int(page)
                self.setImage(at: Int(page))
            }
            return section
        }
        
        return layout
    }
    
    @IBAction func skipToLoginTapped(_ sender: UIButton) {
        // Fires a closure to open the login view controller
        self.skipToLoginAction()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        self.scrollSlide()
    }
}

// MARK: -- Helper functions

extension TutorialViewController {
    private func getTimeInterval() -> Double {
        let interval: Double = 5.0
        return interval
    }
    
    private func setImage(at index: Int) {
        self.slideImageView.image = UIImage(named: self.slides[index].imageName ?? "", in: .module, compatibleWith: nil)
    }
    
    private func setAnimation(at index: Int) {
        LottieAnimationManager.showAnimation(onView: self.animationView, withJsonFileName: self.slides[index].animationName ?? "") { _ in }
    }
    
    private func scrollSlide() {
        if let coll = collectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if let row = indexPath?.row, let section = indexPath?.section {
                    print("\(row):\(self.slides.count)")
                    if (row  == self.slides.count-1) {
                        skipToLoginAction()
                    } else if (row  < (self.slides.count - 1)) {
                        let indexPath1: IndexPath?
                        indexPath1 = IndexPath(row: row + 1, section: section)
                        self.pageController.currentPage = row
                        self.setImage(at: row)
                        coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                    } else {
                        let indexPath1: IndexPath?
                        indexPath1 = IndexPath(row: 1, section: section)
                        self.pageController.currentPage = 0
                        coll.scrollToItem(at: indexPath1!, at: .right, animated: false)
                    }
                }
            }
        }
    }
}

// MARK: -- UICollectionView functions

extension TutorialViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = slides.count
        
        pageController.numberOfPages = count
        pageController.isHidden = !(count > 1)
        
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextSlideCollectionViewCell", for: indexPath) as? TextSlideCollectionViewCell {
            
            cell.configureCell(with: slides[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
}
