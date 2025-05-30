//
//  JCAPPAuthFacePopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit

class JCAPPAuthFacePopView: JCAPPBasePopView {

    private lazy var imgView: UIImageView = UIImageView(image: UIImage(named: "certification_card_face"))
    private lazy var errorImgView: UIImageView = UIImageView(image: UIImage(named: "certification_card_face_error"))
    
    override func JCAPPbuildPopViews() {
        super.JCAPPbuildPopViews()
        self.JCAPPpopTitleLab.text = String.JCAPP_mhssjdlsiString()
        self.JCAPPtopImgView.image = UIImage(named: "pop_top_bg3")
        self.JCAPPtipLab.text = String.JCAPP_dfcmskmdString()
        
        self.JCAPPcontentView.addSubview(self.imgView)
        self.JCAPPcontentView.addSubview(self.errorImgView)
    }
    
    override func JCAPPlayoutPopViews() {
        super.JCAPPlayoutPopViews()
        
        self.imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.JCAPPtipLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
        }
        
        self.errorImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.imgView.snp.bottom).offset(APP_PADDING_UNIT * 6)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 2)
        }
    }
    
    public override class func JCAPPconvenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
        let view = JCAPPAuthFacePopView(frame: UIScreen.main.bounds, showCloseButton: show)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}
