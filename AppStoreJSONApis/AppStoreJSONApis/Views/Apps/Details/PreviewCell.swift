//
//  PreviewCell.swift
//  AppStoreJSONApis
//
//  Created by Максим Самодуров on 22.12.2022.
//

import UIKit

class PreviewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
