//
//  PaletteCollectionViewCell.swift
//  Training_Doodle
//
//  Created by mmslab-mini on 2020/7/3.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class PaletteCollectionViewCell: UICollectionViewCell {

    @IBOutlet var ColorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setCell(color: UIColor) {
        ColorLabel.backgroundColor = color
    }

}
