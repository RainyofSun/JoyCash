//
//  JCAPPMineActionItem.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

class JCAPPMineActionItem: UIControl {

    open var markUrl: String?
    
    private lazy var actionImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var actionTitleLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.systemFont(ofSize: 16), labelColor: BLACK_COLOR_26264A)
    private lazy var arrowImgView: UIImageView = UIImageView(image: UIImage(named: "mine_arrow"))
    private lazy var lineView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.hexStringColor(hexString: "#CACDD4")
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.actionTitleLab.textAlignment = .left
        
        self.addSubview(self.actionImgView)
        self.addSubview(self.actionTitleLab)
        self.addSubview(self.arrowImgView)
        self.addSubview(self.lineView)
        
        self.arrowImgView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 5)
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 3)
            make.size.equalTo(24)
        }
        
        
        self.actionImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 5)
            make.centerY.size.equalTo(self.arrowImgView)
        }
        
        self.actionTitleLab.snp.makeConstraints { make in
            make.left.equalTo(self.actionImgView.snp.right).offset(APP_PADDING_UNIT * 2)
            make.centerY.equalTo(self.arrowImgView)
        }
        
        self.lineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 5)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func setMineActionItemTitle(_ title: String?, image: String?, showLine: Bool) {
        self.actionTitleLab.text = title
        if let _text_url = image {
            if _text_url.hasPrefix("http"), let _url = URL(string: _text_url) {
                self.actionImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
            } else {
                self.actionImgView.image = UIImage(named: _text_url)
            }
        }
        
        self.lineView.isHidden = !showLine
    }
    
    public func setMineActionItemTitleShowVersion(_ title: String?, image: String?, showLine: Bool) {
        self.arrowImgView.isHidden = true
        let view = UILabel.buildJoyCashLabel(font: UIFont.systemFont(ofSize: 16), labelColor: BLACK_COLOR_26264A)
        if let _version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            view.text = "V" + _version
        }
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.right.centerY.equalTo(self.arrowImgView)
        }
        self.setMineActionItemTitle(title, image: image, showLine: showLine)
    }
}
