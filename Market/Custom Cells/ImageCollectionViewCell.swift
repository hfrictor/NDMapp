//
//  ImageCollectionViewCell.swift
//  Market
//
//  Created by Hayden Frea on 25/07/2019.
//  Copyright © 2019 Hayden Frea. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage) {
        
        imageView.image = itemImage
    }
    
}
