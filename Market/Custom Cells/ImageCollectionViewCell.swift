//
//  ImageCollectionViewCell.swift
//  Market
//
//  Created by David Kababyan on 25/07/2019.
//  Copyright © 2019 David Kababyan. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage) {
        
        imageView.image = itemImage
    }
    
}
