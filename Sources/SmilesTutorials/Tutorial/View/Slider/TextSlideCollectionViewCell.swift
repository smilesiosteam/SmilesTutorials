//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 21/06/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities

final class TextSlideCollectionViewCell: UICollectionViewCell {
    
    // MARK: -- Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViewUI()
    }
    
    func setupViewUI() {
        title.font = SmilesFonts.circular.getFont(style: .medium, size: 22)
        title.textColor = .appRevampFilterTextColor
        
        subTitle.font = SmilesFonts.circular.getFont(style: .book, size: 14)
        subTitle.textColor = .appRevampClosingTextGrayColor
    }
    
    func configureCell(with slide: Slide) {
        title.text = slide.title
        subTitle.text = slide.subTitle
    }
}
