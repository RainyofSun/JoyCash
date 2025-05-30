//
//  JCAPPMineActionItem.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

class JCAPPMineActionItem: UIControl {

    open var markUrl: String?
    
    private lazy var JCAPPactionImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var JCAPPactionTitleLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.systemFont(ofSize: 16), labelColor: BLACK_COLOR_26264A)
    private lazy var arrowImgView: UIImageView = UIImageView(image: UIImage(named: "mine_arrow"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.JCAPPactionTitleLab.textAlignment = .left
        
        self.addSubview(self.JCAPPactionImgView)
        self.addSubview(self.JCAPPactionTitleLab)
        self.addSubview(self.arrowImgView)
        
        self.arrowImgView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 5)
            make.centerY.equalToSuperview().inset(APP_PADDING_UNIT * 4)
            make.size.equalTo(20)
        }
        
        
        self.JCAPPactionImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 5)
            make.size.equalTo(30)
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 3)
        }
        
        self.JCAPPactionTitleLab.snp.makeConstraints { make in
            make.left.equalTo(self.JCAPPactionImgView.snp.right).offset(APP_PADDING_UNIT * 2)
            make.centerY.equalTo(self.arrowImgView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func JCAPPsetMineActionItemTitle(_ title: String?, image: String?) {
        self.JCAPPactionTitleLab.text = title
        if let _text_url = image {
            if _text_url.hasPrefix("http"), let _url = URL(string: _text_url) {
                self.JCAPPactionImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
            } else {
                self.JCAPPactionImgView.image = UIImage(named: _text_url)
            }
        }
    }
    
    public func JCAPPsetMineActionItemTitleShowVersion(_ title: String?, image: String?) {
        self.arrowImgView.isHidden = true
        let view = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.systemFont(ofSize: 16), labelColor: BLACK_COLOR_26264A)
        if let _version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            view.text = "V" + _version
        }
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.right.centerY.equalTo(self.arrowImgView)
        }
        self.JCAPPsetMineActionItemTitle(title, image: image)
    }
}
