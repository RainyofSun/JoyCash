//
//  JCAPPUserLoginViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
import Toast

class JCAPPUserLoginViewController: JCAPPBaseViewController, HideNavigationBarProtocol {

    private lazy var bgImgView: UIImageView = UIImageView(image: UIImage(named: "login_bg"))
    private lazy var backBtn: UIButton = UIButton.buildJoyCashImageButton("login_back")
    private lazy var logoImgView: UIImageView = UIImageView(image: UIImage(named: "login_logo"))
    private lazy var logoTipImgView: UIImageView = UIImageView(image: UIImage(named: "login_tip"))
    private lazy var phoneTextFiled: JCAPPForbidActionTextFiled = JCAPPForbidActionTextFiled.buildJoyCashLoginTextFiled(placeHolder: NSAttributedString(string: "Enter your phone number", attributes: [.foregroundColor: GRAY_COLOR_2F3127, .font: UIFont.systemFont(ofSize: 14)]))
    private lazy var codeTextFiled: JCAPPForbidActionTextFiled = {
        let view = JCAPPForbidActionTextFiled.buildJoyCashLoginTextFiled(placeHolder: NSAttributedString(string: "Verification code", attributes: [.foregroundColor: GRAY_COLOR_2F3127, .font: UIFont.systemFont(ofSize: 14)]))
        let code_timer_btn: JCAPPCodeTimerButton = JCAPPCodeTimerButton(frame: CGRectZero)
        view.rightView = code_timer_btn
        view.rightViewMode = .always
        self.msgTimerBtn = code_timer_btn
        
        return view
    }()
    
    private lazy var voiceBtn: UIButton = UIButton.buildJoyCashImageButton("login_voice_code_nor", disableImg: "login_voice_code")
    private lazy var protocolView: JCAPPProtocolView = JCAPPProtocolView(frame: CGRectZero)
    private lazy var loginBtn: JCAPPActivityButton = JCAPPActivityButton.buildJoyCashGradientLoadingButton("Login", cornerRadius: 24)
    
    private var msgTimerBtn: JCAPPCodeTimerButton?
    
    override func buildViewUI() {
        super.buildViewUI()
        self.gradientView.isHidden = true
        
        self.protocolView.protocolDelegate = self
        self.protocolView.setProtocol("Privacy Agreement")
        
        self.backBtn.addTarget(self, action: #selector(clickBackButton(sender: )), for: UIControl.Event.touchUpInside)
        self.voiceBtn.addTarget(self, action: #selector(clickVoiceCodeButton(sender: )), for: UIControl.Event.touchUpInside)
        self.loginBtn.addTarget(self, action: #selector(clickLoginButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.view.insertSubview(self.bgImgView, at: .zero)
        self.view.addSubview(self.backBtn)
        self.contentView.addSubview(self.logoImgView)
        self.contentView.addSubview(self.logoTipImgView)
        self.contentView.addSubview(self.phoneTextFiled)
        self.contentView.addSubview(self.codeTextFiled)
        self.contentView.addSubview(self.voiceBtn)
        self.contentView.addSubview(self.protocolView)
        self.contentView.addSubview(self.loginBtn)
        
        self.msgTimerBtn?.addTarget(self, action: #selector(clickCodeButton(sender: )), for: UIControl.Event.touchUpInside)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.backBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDevice.xp_statusBarHeight() + APP_PADDING_UNIT * 5)
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 5)
            make.size.equalTo(32)
        }
        
        self.contentView.snp.remakeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.backBtn.snp.bottom)
        }
        
        self.logoImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 10)
            make.top.equalToSuperview().offset(APP_PADDING_UNIT * 7)
        }
        
        self.logoTipImgView.snp.makeConstraints { make in
            make.left.equalTo(self.logoImgView)
            make.top.equalTo(self.logoImgView.snp.bottom).offset(APP_PADDING_UNIT * 4)
        }
        
        self.phoneTextFiled.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 6)
            make.top.equalTo(self.logoTipImgView.snp.bottom).offset(APP_PADDING_UNIT * 30)
            make.size.equalTo(CGSize(width: ScreenWidth - APP_PADDING_UNIT * 12, height: 54))
        }
        
        self.codeTextFiled.snp.makeConstraints { make in
            make.horizontalEdges.height.equalTo(self.phoneTextFiled)
            make.top.equalTo(self.phoneTextFiled.snp.bottom).offset(APP_PADDING_UNIT * 4)
        }
        
        self.voiceBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.codeTextFiled)
            make.top.equalTo(self.codeTextFiled.snp.bottom).offset(APP_PADDING_UNIT * 4)
        }
        
        self.protocolView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 12)
            make.top.equalTo(self.voiceBtn.snp.bottom).offset(APP_PADDING_UNIT * 12)
            make.width.lessThanOrEqualTo(ScreenWidth - APP_PADDING_UNIT * 15)
        }
        
        self.loginBtn.snp.makeConstraints { make in
            make.horizontalEdges.height.equalTo(self.codeTextFiled)
            make.top.equalTo(self.protocolView.snp.bottom).offset(APP_PADDING_UNIT * 4)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 10)
        }
    }
}

extension JCAPPUserLoginViewController: APPProtocolDelegate {
    func gotoProtocol() {
        if let _url = JCAPPPublic.shared.privacyURL {
            JCAPPPageRouting.shared.JoyCashPageRouter(routeUrl: _url, backToRoot: true)
        }
    }
}

@objc private extension JCAPPUserLoginViewController {
    func clickBackButton(sender: UIButton) {
        self.navigationController?.dismiss(animated: true)
    }
    
    func clickCodeButton(sender: JCAPPCodeTimerButton) {
        guard let _phone = self.phoneTextFiled.text else {
            self.view.makeToast("Please enter your phone number")
            return
        }
        
        sender.isEnabled = false
        self.buryBeginTime = Date().jk.dateToTimeStamp()
        self.view.makeToastActivity(CSToastPositionCenter)
        
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/discoveries", requestParams: ["incorporated": _phone])) { [weak self] (task: URLSessionDataTask, res: JCAPPSuccessResponse) in
            sender.isEnabled = true
            self?.view.hideToastActivity()
            self?.view.makeToast(res.responseMsg)
            sender.start()
            if let _first_response = self?.codeTextFiled.canBecomeFirstResponder, _first_response {
                self?.codeTextFiled.becomeFirstResponder()
            }
        } failure: {[weak self] _, error in
            sender.isEnabled = true
            self?.view.hideToastActivity()
        }
    }
    
    func clickVoiceCodeButton(sender: UIButton) {
        guard let _p = self.phoneTextFiled.text else {
            self.view.makeToast("Please enter your phone number")
            return
        }
        
        sender.isEnabled = false
        self.buryBeginTime = Date().jk.dateToTimeStamp()
        self.view.makeToastActivity(CSToastPositionCenter)
        
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/physiology", requestParams: ["incorporated": _p])) { [weak self] (task: URLSessionDataTask, res: JCAPPSuccessResponse) in
            sender.isEnabled = true
            self?.view.hideToastActivity()
            self?.view.makeToast(res.responseMsg)
            if let _first_response = self?.codeTextFiled.canBecomeFirstResponder, _first_response {
                self?.codeTextFiled.becomeFirstResponder()
            }
        } failure: {[weak self] _, error in
            sender.isEnabled = true
            self?.view.hideToastActivity()
        }
    }
    
    func clickLoginButton(sender: JCAPPActivityButton) {
        guard self.protocolView.hasSelected else {
            self.view.makeToast("Please confirm whether you agree to agreement")
            return
        }
        
        guard let _p = self.phoneTextFiled.text else {
            self.view.makeToast("Please enter your phone number")
            return
        }
        
        guard let _c = self.codeTextFiled.text else {
            self.view.makeToast("Please enter the verification code")
            return
        }
        
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/prize", requestParams: ["damadian": _p, "raymond": _c])) { [weak self] (task: URLSessionDataTask, res: JCAPPSuccessResponse) in
            sender.stopAnimation()
            guard let _dict = res.jsonDict else {
                return
            }
            // 记录登录态
            JCAPPPublic.shared.appLoginInfo = JCAPPUserLoginModel.model(with: _dict)
            JCAPPPublic.shared.encoderUserLogin()
            // 埋点
            JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCRiskControlPointsType.JC_APP_Register, beginTime: self?.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
            self?.msgTimerBtn?.stop()
            self?.navigationController?.dismiss(animated: true)
        } failure: {[weak self] _, error in
            sender.stopAnimation()
            self?.codeTextFiled.jk.shake(times: 5, interval: 0.05) {
                self?.codeTextFiled.text = ""
                self?.codeTextFiled.becomeFirstResponder()
            }
        }
        
    }
}
