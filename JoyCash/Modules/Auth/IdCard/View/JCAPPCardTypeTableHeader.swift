//
//  JCAPPCardTypeTableHeader.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/26.
//

import UIKit

class JCAPPCardTypeTableHeader: UITableViewHeaderFooterView {

    open var clickHeaderClousre: (() -> Void)?
    
    private lazy var contentControl: UIControl = {
        let view = UIControl(frame: CGRectZero)
        view.backgroundColor = UIColor.hexStringColor(hexString: "#F9F9F9")
        return view
    }()
    
    private lazy var titleLab: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 18)
        view.textColor = UIColor.hexStringColor(hexString: "#2F3127")
        return view
    }()
    
    private lazy var arrowImgView: UIImageView = UIImageView(image: UIImage(named: "direction_caret_down"))
    private var _expand: Bool = false
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentControl.addTarget(self, action: #selector(clickHeader(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.contentControl)
        self.contentControl.addSubview(self.titleLab)
        self.contentControl.addSubview(self.arrowImgView)
        
        self.contentControl.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(ScreenWidth - APP_PADDING_UNIT * 14)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        self.arrowImgView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(15)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self._expand {
            self.contentControl.jk.addCorner(conrners: [.topLeft, .topRight], radius: 8)
        } else {
            self.contentControl.jk.addCorner(conrners: .allCorners, radius: 8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadHeaderTitle(_ title: String?, isExpand: Bool = false) {
        self.titleLab.text = title
        self._expand = isExpand
        if self._expand {
            self.arrowImgView.transform = CGAffineTransform(rotationAngle: Double.pi)
        } else {
            self.arrowImgView.transform = CGAffineTransform.identity
        }
    }
}

@objc private extension JCAPPCardTypeTableHeader {
    func clickHeader(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.clickHeaderClousre?()
    }
}
