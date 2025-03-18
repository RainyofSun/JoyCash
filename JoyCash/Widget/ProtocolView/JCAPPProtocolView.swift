//
//  JCAPPProtocolView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/21.
//

import UIKit

protocol APPProtocolDelegate: AnyObject {
    func gotoProtocol()
}

class JCAPPProtocolView: UIView {

    weak open var protocolDelegate: APPProtocolDelegate?
    open var hasSelected: Bool {
        return self.agreeBtn.isSelected
    }
    
    private lazy var agreeBtn: UIButton = UIButton.buildJoyCashImageButton("login_agree_nor", selectedImg: "login_agree_sel")
    private lazy var protocolBtn: UIButton = {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.titleLabel?.numberOfLines = .zero
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.agreeBtn.addTarget(self, action: #selector(clickAgreeButton(sender: )), for: UIControl.Event.touchUpInside)
        self.protocolBtn.addTarget(self, action: #selector(clickProtocolButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.agreeBtn)
        self.addSubview(self.protocolBtn)
        
        self.protocolBtn.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT)
            make.height.greaterThanOrEqualTo(APP_PADDING_UNIT * 6)
            make.left.equalTo(self.agreeBtn.snp.right).offset(APP_PADDING_UNIT)
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 2)
        }
        
        self.agreeBtn.snp.makeConstraints { make in
            make.size.equalTo(15)
            make.centerY.equalTo(self.protocolBtn)
            make.left.equalToSuperview().offset(APP_PADDING_UNIT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func setProtocol(_ protocolName: String, defaultSelected: Bool = true) {
        let string: NSMutableAttributedString = NSMutableAttributedString(string: "I have read and agree with ", attributes: [.foregroundColor: UIColor.init(hexString: "#272931")!, .font: UIFont.systemFont(ofSize: 12)])
        string.append(NSAttributedString(string: protocolName, attributes: [.foregroundColor: BLUE_COLOR_4169F6, .font: UIFont.systemFont(ofSize: 12), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: BLUE_COLOR_4169F6]))
        
        self.protocolBtn.setAttributedTitle(string, for: UIControl.State.normal)
        
        self.agreeBtn.isSelected = defaultSelected
    }
    
    public func setNewProtocol(_ protocolText: String, defaultSelected: Bool = true) {
        self.protocolBtn.setTitle(protocolText, for: UIControl.State.normal)
        self.protocolBtn.setTitleColor(UIColor.hexStringColor(hexString: "#272931"), for: UIControl.State.normal)
        self.protocolBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.agreeBtn.isSelected = defaultSelected
    }
}

@objc private extension JCAPPProtocolView {
    func clickAgreeButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func clickProtocolButton(sender: UIButton) {
        self.protocolDelegate?.gotoProtocol()
    }
}
