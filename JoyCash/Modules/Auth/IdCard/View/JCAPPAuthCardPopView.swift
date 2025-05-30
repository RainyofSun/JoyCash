//
//  JCAPPAuthCardPopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit

class JCAPPAuthCardPopView: JCAPPBasePopView {

    private lazy var JCAPPimgView: UIImageView = UIImageView(image: UIImage(named: "certification_card_type"))
    private lazy var JCAPPerrorImgView: UIImageView = UIImageView(image: UIImage(named: "certification_card_error"))
    
    override func JCAPPbuildPopViews() {
        super.JCAPPbuildPopViews()
        self.JCAPPpopTitleLab.text = String.JCAPP_mhssjdlsiString()
        self.JCAPPtopImgView.image = UIImage(named: "pop_top_bg3")
        self.JCAPPtipLab.text = String.JCAPP_fgshkwjcdString()
        
        self.JCAPPcontentView.addSubview(self.JCAPPtipLab)
        self.JCAPPcontentView.addSubview(self.JCAPPimgView)
        self.JCAPPcontentView.addSubview(self.JCAPPerrorImgView)
    }
    
    override func JCAPPlayoutPopViews() {
        super.JCAPPlayoutPopViews()
        
        self.JCAPPimgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.JCAPPtipLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
        }
        
        self.JCAPPerrorImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.JCAPPimgView.snp.bottom).offset(APP_PADDING_UNIT * 6)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 2)
        }
    }
    
    public override class func JCAPPconvenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
        let view = JCAPPAuthCardPopView(frame: UIScreen.main.bounds, showCloseButton: show)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}
