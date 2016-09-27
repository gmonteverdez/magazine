//
//  EdicionesCellTableViewCell.swift
//  Revista Muros
//
//  Created by Gerardo Israel Monteverde on 2/12/16.
//  Copyright © 2016 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit

class EdicionesCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Fecha: UILabel!
    
    @IBOutlet weak var Cover: UIImageView!
    
    @IBOutlet weak var Edicion: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
