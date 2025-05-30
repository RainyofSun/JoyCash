//
//  JCAPPMineCancelPopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

class JCAPPMineCancelPopView: JCAPPBasePopView {

    private lazy var JCAPPcancelTipLab: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.numberOfLines = .zero
        return view
    }()
    
    private(set) lazy var JCAPPprotocolView: ProtocolView = {
        let view = ProtocolView(frame: CGRectZero)
        view.setProtocol(NSAttributedString(string: ""), protocolPrefix: NSAttributedString(string: String.JCAPP_tsuowodkslString(), attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#272931"), .font: UIFont.systemFont(ofSize: 12)]), defaultSelected: false)
        view.setAgreeButton(UIImage(named: "login_agree_nor")!, selectedImg: UIImage(named: "login_agree_sel")!)
        return view
    }()
    
    override func JCAPPbuildPopViews() {
        super.JCAPPbuildPopViews()
        self.JCAPPtopImgView.image = UIImage(named: "pop_top_bg1")
        self.JCAPPpopTitleLab.text = String.JCAPP_siurjskslwllString()
        self.JCAPPresetConfirmTitle("Cancel", backTitle: String.JCAPP_ujujdksljdlkString())
        self.JCAPPScrollContentView.isHidden = false
        
        let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paraStyle.paragraphSpacing = APP_PADDING_UNIT * 2
        let dict1: [NSAttributedString.Key : Any] = [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle]
        let dict2: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.hexStringColor(hexString: "#554239", alpha: 0.5), .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle]
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: String.JCAPP_yshdowkskdpslString(), attributes: dict1)
        attributeString.append(NSAttributedString(string: String.JCAPP_iksldkopekdlString(), attributes: dict2))
        attributeString.append(NSAttributedString(string: String.JCAPP_fgjskkcskaksldlString(), attributes: dict1))
        attributeString.append(NSAttributedString(string: String.JCAPP_rjskpaplsjcmString(), attributes: dict2))
        attributeString.append(NSAttributedString(string: String.JCAPP_dsoeldakslString(), attributes: dict1))
        attributeString.append(NSAttributedString(string: String.JCAPP_wlshfnbcnsmString(), attributes: dict2))
        
        self.JCAPPcancelTipLab.attributedText = attributeString
        
        self.JCAPPScrollContentView.addSubview(self.JCAPPcancelTipLab)
        self.JCAPPbgView.addSubview(self.JCAPPprotocolView)
    }
    
    override func JCAPPlayoutPopViews() {
        super.JCAPPlayoutPopViews()
        
        self.JCAPPcancelTipLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.width.equalTo(ScreenWidth - APP_PADDING_UNIT * 24)
            make.top.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.height.lessThanOrEqualTo(300)
            make.height.greaterThanOrEqualTo(100)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
        }
        
        self.JCAPPprotocolView.snp.makeConstraints { make in
            make.left.equalTo(self.JCAPPcancelTipLab)
            make.width.lessThanOrEqualTo(ScreenWidth * 0.7)
            make.top.equalTo(self.JCAPPScrollContentView.snp.bottom).offset(APP_PADDING_UNIT * 4)
        }
        
        self.JCAPPconfirmBtn.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 13)
            make.top.equalTo(self.JCAPPprotocolView.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.height.equalTo(46)
        }
    }
    
    public override class func JCAPPconvenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
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
