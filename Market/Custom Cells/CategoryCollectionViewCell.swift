//
//  CategoryCollectionViewCell.swift
//  Market
//
//  Created by Hayden Frea on 14/07/2019.
//  Copyright © 2019 Hayden Frea. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func generateCell(_ category: Category) {
        
        nameLabel.text = category.name
        imageView.image = category.image
    }
    
}
