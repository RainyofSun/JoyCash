//
//  JCAPPCardTypeTableHeader.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/26.
//

import UIKit

class JCAPPCardTypeTableHeader: UITableViewHeaderFooterView {

    open var clickHeaderClousre: (() -> Void)?
    
    private lazy var JCAPPcontentControl: UIControl = {
        let view = UIControl(frame: CGRectZero)
        view.backgroundColor = UIColor.hexStringColor(hexString: "#F9F9F9")
        return view
    }()
    
    private lazy var JCAPPtitleLab: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 18)
        view.textColor = UIColor.hexStringColor(hexString: "#2F3127")
        return view
    }()
    
    private lazy var JCAPParrowImgView: UIImageView = UIImageView(image: UIImage(named: "direction_caret_down"))
    private var JCAPP_expand: Bool = false
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.JCAPPcontentControl.addTarget(self, action: #selector(JCAPPclickHeader(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.JCAPPcontentControl)
        self.JCAPPcontentControl.addSubview(self.JCAPPtitleLab)
        self.JCAPPcontentControl.addSubview(self.JCAPParrowImgView)
        
        self.JCAPPcontentControl.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(ScreenWidth - APP_PADDING_UNIT * 14)
        }
        
        self.JCAPPtitleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        self.JCAPParrowImgView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(15)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.JCAPP_expand {
            self.JCAPPcontentControl.jk.addCorner(conrners: [.topLeft, .topRight], radius: 8)
        } else {
            self.JCAPPcontentControl.jk.addCorner(conrners: .allCorners, radius: 8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func JCAPPreloadHeaderTitle(_ title: String?, isExpand: Bool = false) {
        self.JCAPPtitleLab.text = title
        self.JCAPP_expand = isExpand
        if self.JCAPP_expand {
            self.JCAPParrowImgView.transform = CGAffineTransform(rotationAngle: Double.pi)
        } else {
            self.JCAPParrowImgView.transform = CGAffineTransform.identity
        }
    }
}

@objc private extension JCAPPCardTypeTableHeader {
    func JCAPPclickHeader(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.clickHeaderClousre?()
    }
}
