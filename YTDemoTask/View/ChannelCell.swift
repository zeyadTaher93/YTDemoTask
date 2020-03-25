//
//  ChannelCell.swift
//  YTDemoTask
//
//  Created by zeyad on 3/24/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import UIKit
import SDWebImage
class ChannelCell: UITableViewCell {

    @IBOutlet weak var thumbnil: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var channelCellViewModel : ChannelCellViewModel? {
         didSet {
            thumbnil?.sd_setImage(with: URL( string: channelCellViewModel?.thumbnilUrl ?? "" ), completed: nil)
            title.text = channelCellViewModel?.titleText
            
         }
     }
}
