//
//  JCAPPMineLoanProtocolPopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

class JCAPPMineLoanProtocolPopView: JCAPPBasePopView {
    
    override func JCAPPbuildPopViews() {
        super.JCAPPbuildPopViews()
        self.JCAPPtopImgView.image = UIImage(named: "pop_top_bg2")
        self.JCAPPpopTitleLab.text = String.JCAPP_iopslkdjjdString()
        self.JCAPPtipLab.text = String.JCAPP_hsyenmcikskString(name: Bundle.jk.appDisplayName)
    }
}
