//
//  JCAPPMineCancelPopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

class JCAPPMineCancelPopView: JCAPPBasePopView {

    private lazy var cancelTipLab: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.numberOfLines = .zero
        return view
    }()
    
    private(set) lazy var protocolView: JCAPPProtocolView = {
        let view = JCAPPProtocolView(frame: CGRectZero)
        view.setProtocol("Loan Agreement", defaultSelected: false)
        return view
    }()
    
    override func buildPopViews() {
        super.buildPopViews()
        self.topImgView.image = UIImage(named: "pop_top_bg1")
        self.popTitleLab.text = "Canceling your account will cause you to permanently lose the following data and functions:"
        self.resetConfirmTitle("Cancel", backTitle: "Deregister account")
        
        let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paraStyle.paragraphSpacing = APP_PADDING_UNIT * 2
        let dict1: [NSAttributedString.Key : Any] = [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle]
        let dict2: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.hexStringColor(hexString: "#554239", alpha: 0.5), .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle]
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "· History:\n", attributes: dict1)
        attributeString.append(NSAttributedString(string: "All history will be deleted and cannot be restored\n", attributes: dict2))
        attributeString.append(NSAttributedString(string: "· Personal information:\n", attributes: dict1))
        attributeString.append(NSAttributedString(string: "including your identity information, personal data and other related information\n", attributes: dict2))
        attributeString.append(NSAttributedString(string: "· App permission procedure:\n", attributes: dict1))
        attributeString.append(NSAttributedString(string: "You will no longer be able to use any features and services of this product\n", attributes: dict2))
        
        self.cancelTipLab.attributedText = attributeString
        
        self.protocolView.protocolDelegate = self
        
        self.contentView.addSubview(self.cancelTipLab)
        self.contentView.addSubview(self.protocolView)
    }
    
    override func layoutPopViews() {
        super.layoutPopViews()
        
        self.cancelTipLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
            make.top.equalToSuperview().offset(APP_PADDING_UNIT * 4)
        }
        
        self.protocolView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 9)
            make.top.equalTo(self.tipLab.snp.bottom).offset(APP_PADDING_UNIT * 4)
            make.width.lessThanOrEqualTo(ScreenWidth - APP_PADDING_UNIT * 28)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
        }
    }
    
    public override class func convenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
        let view = JCAPPMineCancelPopView(frame: UIScreen.main.bounds, showCloseButton: show)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}

extension JCAPPMineCancelPopView: APPProtocolDelegate {
    func gotoProtocol() {
        guard let _super_view = self.superview else {
            return
        }
        
        let protocolPopView = JCAPPMineLoanProtocolPopView(frame: UIScreen.main.bounds)
        protocolPopView.alpha = .zero
        _super_view.addSubview(protocolPopView)
        
        protocolPopView.clickCloseClosure = {(popView: JCAPPBasePopView, isConfirm: Bool) in
            UIView.transition(with: popView, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                popView.alpha = .zero
            }) { _ in
                self.alpha = 1
                popView.removeFromSuperview()
            }
        }
        
        UIView.transition(with: protocolPopView, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            protocolPopView.alpha = 1
        }) { _ in
            self.alpha = .zero
        }
    }
}
