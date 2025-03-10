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
    
    override func buildPopViews() {
        super.buildPopViews()
        self.popTitleLab.text = "Demonstration"
        self.topImgView.image = UIImage(named: "pop_top_bg3")
        self.tipLab.text = "Please aim the camera at your face during verification and follow the prompts to operate."
        
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.errorImgView)
    }
    
    override func layoutPopViews() {
        super.layoutPopViews()
        
        self.imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.tipLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
        }
        
        self.errorImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.imgView.snp.bottom).offset(APP_PADDING_UNIT * 6)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 2)
        }
    }
    
    public override class func convenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
        let view = JCAPPAuthFacePopView(frame: UIScreen.main.bounds, showCloseButton: show)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}
