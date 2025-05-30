//
//  JCAPPMineLogoutPopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

class JCAPPMineLogoutPopView: JCAPPBasePopView {

    override func JCAPPbuildPopViews() {
        super.JCAPPbuildPopViews()
        self.JCAPPtopImgView.image = UIImage(named: "pop_top_bg1")
        self.JCAPPpopTitleLab.text = String.JCAPP_owkskpkdjString()
        self.JCAPPresetConfirmTitle("Cancel", backTitle: "Log out")
    }
    
    public override class func JCAPPconvenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
        let view = JCAPPMineLogoutPopView(frame: UIScreen.main.bounds, showCloseButton: show)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}
