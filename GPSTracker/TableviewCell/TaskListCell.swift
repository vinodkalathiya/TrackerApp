//
//  TaskListCell.swift
//  GPSTracker
//
//  Created by sensussoft on 1/30/18.
//  Copyright © 2018 Sensu Soft. All rights reserved.
//

import UIKit

class TaskListCell: UITableViewCell {

    @IBOutlet var viewMain: UIView!
    @IBOutlet var lblTaskId: UILabel!
    @IBOutlet var lblTaskType: UILabel!
    @IBOutlet var lblTaskNote: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMain.layer.shadowColor = UIColor.darkGray.cgColor
        viewMain.layer.shadowOffset = CGSize(width: 0, height: 3)
        viewMain.layer.shadowOpacity = 0.3
        viewMain.layer.shadowRadius = 3.0
        viewMain.layer.masksToBounds = false
        viewMain.layer.cornerRadius = 8
        viewMain.layer.borderColor = RGBCOLOR(209, g:209,b:211).cgColor
        viewMain.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func RGBCOLOR(_ r: CGFloat, g: CGFloat , b: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
}
