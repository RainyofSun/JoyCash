//
//  JCAPPLeftImageRightTextButton.swift
//  JoyCash
//
//  Created by 一刻 on 2025/5/14.
//

import UIKit

class JCAPPLeftImageRightTextButton: JCAPPTopImgBottomTextButton {

    override func JCAPPsetImage(_ image: String, text: NSAttributedString, distance: CGFloat = APP_PADDING_UNIT * 2, bottomDistance: CGFloat = APP_PADDING_UNIT) {
        self.topImgView.image = UIImage(named: image)
        self.bottomLab.attributedText = text
        
        self.topImgView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 3)
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 2)
            make.size.equalTo(40)
        }
        
        self.bottomLab.snp.makeConstraints { make in
            make.left.equalTo(self.topImgView.snp.right).offset(APP_PADDING_UNIT * 2)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 2)
        }
    }
}
