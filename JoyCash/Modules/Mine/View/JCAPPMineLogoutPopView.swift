//
//  JCAPPMineLogoutPopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

class JCAPPMineLogoutPopView: JCAPPBasePopView {

    override func buildPopViews() {
        super.buildPopViews()
        self.topImgView.image = UIImage(named: "pop_top_bg1")
        self.popTitleLab.text = "You're just a little bit away from getting a loan, are you sure to exit?"
        self.resetConfirmTitle("Cancel", backTitle: "Log out")
    }
    
    public override class func convenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
        let view = JCAPPMineLogoutPopView(frame: UIScreen.main.bounds, showCloseButton: show)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}
