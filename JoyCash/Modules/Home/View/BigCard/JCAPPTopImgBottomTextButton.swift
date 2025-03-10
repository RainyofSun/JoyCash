//
//  JCAPPTopImgBottomTextButton.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

class JCAPPTopImgBottomTextButton: UIControl {

    private lazy var topImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var bottomLab: UILabel = UILabel.buildJoyCashLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.topImgView)
        self.addSubview(self.bottomLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func setImage(_ image: String, text: NSAttributedString, distance: CGFloat = APP_PADDING_UNIT * 2, bottomDistance: CGFloat = APP_PADDING_UNIT) {
        self.topImgView.image = UIImage(named: image)
        self.bottomLab.attributedText = text
        
        self.topImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(APP_PADDING_UNIT)
            make.centerX.equalTo(self.bottomLab)
        }
        
        self.bottomLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT)
            make.width.greaterThanOrEqualTo(40)
            make.top.equalTo(self.topImgView.snp.bottom).offset(distance)
            make.bottom.equalToSuperview().offset(-bottomDistance)
        }
    }
}
