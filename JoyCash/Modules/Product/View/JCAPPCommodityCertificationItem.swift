//
//  JCAPPCommodityCertificationItem.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit

class JCAPPCommodityCertificationItem: UIControl {

    open var authModel: JCAPPAuthorizationModel?
    
    private lazy var leftImgView: UIImageView = UIImageView(frame: CGRectZero)
    private(set) lazy var titleLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.systemFont(ofSize: 14), labelColor: UIColor.hexStringColor(hexString: "#514139"))
    private lazy var rightImgView: UIImageView = UIImageView(image: UIImage(named: "certification_auth"))
    private lazy var completeImgView: UIImageView = UIImageView(image: UIImage(named: "certification_complete"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLab.textAlignment = .left
        self.corner(8).backgroundColor = .white
        self.completeImgView.alpha = .zero
        self.rightImgView.alpha = .zero
        
        self.addSubview(self.leftImgView)
        self.addSubview(self.titleLab)
        self.addSubview(self.rightImgView)
        self.addSubview(self.completeImgView)
        
        self.leftImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 3)
            make.size.equalTo(40)
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 3)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.leftImgView.snp.right).offset(APP_PADDING_UNIT * 3)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        self.rightImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
        }
        
        self.completeImgView.snp.makeConstraints { make in
            make.right.centerY.equalTo(self.rightImgView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadAuthItem(_ authModel: JCAPPAuthorizationModel) {
        self.authModel = authModel
        if let _url_text = authModel.fossils, let _url = URL(string: _url_text) {
            self.leftImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
        
        self.titleLab.text = authModel.graphic
        
        if authModel.protocols {
            UIView.animate(withDuration: 0.3) {
                self.completeImgView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.rightImgView.alpha = 1
            }
        }
    }
}
