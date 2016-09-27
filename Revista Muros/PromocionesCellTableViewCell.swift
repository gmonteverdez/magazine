//
//  PromocionesCellTableViewCell.swift
//  Revista Muros
//
//  Created by Gerardo Israel Monteverde on 2/12/16.
//  Copyright © 2016 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit

class PromocionesCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Cover: UIImageView!
    @IBOutlet weak var Empresa: UILabel!
    @IBOutlet weak var Descripcion: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
