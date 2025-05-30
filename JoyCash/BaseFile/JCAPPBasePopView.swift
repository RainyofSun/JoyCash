//
//  JCAPPBasePopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

class JCAPPBasePopView: UIView {

    open var popDidmissClosure:((JCAPPBasePopView) -> Void)?
    open var clickCloseClosure: ((JCAPPBasePopView, Bool) -> Void)?
    
    private(set) lazy var JCAPPtopImgView: UIImageView = UIImageView(frame: CGRectZero)
    private(set) lazy var JCAPPpopTitleLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.JCAPPgilroyFont(20), labelColor: BLACK_COLOR_26264A)
    
    private(set) lazy var JCAPPtipLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.systemFont(ofSize: 14), labelColor: UIColor.hexStringColor(hexString: "#554239", alpha: 0.5))
    
    private(set) lazy var JCAPPbgView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private(set) lazy var JCAPPcontentView: UIView = UIView(frame: CGRectZero)
    private(set) lazy var JCAPPScrollContentView: UIScrollView = UIScrollView(frame: CGRectZero)
    private(set) lazy var JCAPPconfirmBtn: APPActivityButton = APPActivityButton.JCAPPbuildJoyCashGradientLoadingButton("Confirm", cornerRadius: 23)
    
    private lazy var JCAPPbackBtn: UIButton = {
        let view = UIButton.JCAPPbuildJoyCashNormalButton("Back", titleFont: UIFont.systemFont(ofSize: 14), titleColor: UIColor.hexStringColor(hexString: "#554239", alpha: 0.5))
        view.isHidden = true
        return view
    }()
    
    private lazy var JCAPPcloseBtn: UIButton = {
        let view = UIButton.JCAPPbuildJoyCashImageButton("pop_close")
        view.isHidden = true
        return view
    }()
    
    private var showClose: Bool = false
    
    init(frame: CGRect, showCloseButton show: Bool = false) {
        super.init(frame: frame)
        self.showClose = show
        self.JCAPPbuildPopViews()
        self.JCAPPlayoutPopViews()
    }
    
    deinit {
        deallocPrint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func JCAPPbuildPopViews() {
        self.backgroundColor = UIColor.init(white: .zero, alpha: 0.6)
        
        self.JCAPPpopTitleLab.textAlignment = .left
        self.JCAPPtipLab.textAlignment = .left
        
        self.JCAPPcloseBtn.isHidden = !self.showClose
        self.JCAPPbackBtn.isHidden = self.showClose
        self.JCAPPtopImgView.isHidden = self.showClose
        self.JCAPPScrollContentView.isHidden = true
        
        self.JCAPPcloseBtn.addTarget(self, action: #selector(JCAPPclickCloseButton(sender: )), for: UIControl.Event.touchUpInside)
        self.JCAPPbackBtn.addTarget(self, action: #selector(JCAPPclickCloseButton(sender: )), for: UIControl.Event.touchUpInside)
        self.JCAPPconfirmBtn.addTarget(self, action: #selector(JCAPPclickConfirmButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.JCAPPbgView)
        self.JCAPPbgView.addSubview(self.JCAPPcontentView)
        self.JCAPPbgView.addSubview(self.JCAPPScrollContentView)
        self.addSubview(self.JCAPPtopImgView)
        self.JCAPPbgView.addSubview(self.JCAPPpopTitleLab)
        self.JCAPPbgView.addSubview(self.JCAPPtipLab)
        self.JCAPPbgView.addSubview(self.JCAPPconfirmBtn)
        self.JCAPPbgView.addSubview(self.JCAPPbackBtn)
        self.JCAPPbgView.addSubview(self.JCAPPcloseBtn)
    }
    
    public func JCAPPlayoutPopViews() {
        self.JCAPPbgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(APP_PADDING_UNIT * 8)
            make.height.greaterThanOrEqualTo(200)
        }
        
        self.JCAPPtopImgView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.JCAPPbgView)
            make.height.equalTo((ScreenWidth - APP_PADDING_UNIT * 16) * 0.33)
            make.bottom.equalTo(self.JCAPPbgView.snp.top).offset(APP_PADDING_UNIT * 8)
        }
                
        self.JCAPPScrollContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.JCAPPtipLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
            make.height.greaterThanOrEqualTo(120)
        }
        
        if self.showClose {
            self.JCAPPconfirmBtn.snp.removeConstraints()
            self.JCAPPbackBtn.snp.removeConstraints()
            
            self.JCAPPcloseBtn.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(APP_PADDING_UNIT * 2)
                make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 2)
            }
            
            self.JCAPPpopTitleLab.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(APP_PADDING_UNIT * 6)
                make.centerX.equalToSuperview()
            }
            
            self.JCAPPtipLab.snp.makeConstraints { make in
                make.top.equalTo(self.JCAPPpopTitleLab.snp.bottom)
                make.horizontalEdges.equalTo(self.JCAPPpopTitleLab)
                make.height.greaterThanOrEqualTo(0.1)
            }
            
            self.JCAPPcontentView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.top.equalTo(self.JCAPPtipLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
                make.height.greaterThanOrEqualTo(250)
            }
            
            self.JCAPPconfirmBtn.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 13)
                make.top.equalTo(self.JCAPPcontentView.snp.bottom).offset(APP_PADDING_UNIT * 2)
                make.height.equalTo(46)
                make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 4)
            }
        } else {
            self.JCAPPcloseBtn.snp.removeConstraints()
            
            self.JCAPPpopTitleLab.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
                make.top.equalTo(self.JCAPPtopImgView.snp.bottom).offset(APP_PADDING_UNIT * 3)
            }
            
            self.JCAPPtipLab.snp.makeConstraints { make in
                make.top.equalTo(self.JCAPPpopTitleLab.snp.bottom)
                make.horizontalEdges.equalTo(self.JCAPPpopTitleLab)
                make.height.greaterThanOrEqualTo(0.1)
            }
            
            self.JCAPPcontentView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.top.equalTo(self.JCAPPtipLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
                make.height.greaterThanOrEqualTo(1)
            }
            
            self.JCAPPconfirmBtn.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 13)
                make.top.equalTo(self.JCAPPcontentView.snp.bottom).offset(APP_PADDING_UNIT * 2)
                make.height.equalTo(46)
            }
            
            self.JCAPPbackBtn.snp.makeConstraints { make in
                make.horizontalEdges.height.equalTo(self.JCAPPconfirmBtn)
                make.top.equalTo(self.JCAPPconfirmBtn.snp.bottom).offset(APP_PADDING_UNIT * 3)
                make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 4)
            }
        }
    }
    
    public class func JCAPPconvenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
        let view = JCAPPBasePopView(frame: UIScreen.main.bounds, showCloseButton: show)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
    
    public func JCAPPdismissPop(_ needCall: Bool = true) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = .zero
        } completion: { _ in
            if needCall {
                self.popDidmissClosure?(self)
            }
            self.removeFromSuperview()
        }
    }
    
    public func JCAPPresetConfirmTitle(_ title: String, backTitle: String? = nil) {
        self.JCAPPconfirmBtn.setTitle(title, for: UIControl.State.normal)
        if let _b = backTitle {
            self.JCAPPbackBtn.setTitle(_b, for: UIControl.State.normal)
        }
    }
    
    public func JCAPPhideBack() -> Self {
        self.JCAPPconfirmBtn.snp.removeConstraints()
        self.JCAPPbackBtn.snp.removeConstraints()
        self.JCAPPbackBtn.isHidden = true
        
        self.JCAPPconfirmBtn.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 13)
            make.top.equalTo(self.JCAPPcontentView.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.height.equalTo(46)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 4)
        }
        
        return self
    }
}

@objc extension JCAPPBasePopView {
    func JCAPPclickCloseButton(sender: UIButton) {
        if sender == self.JCAPPcloseBtn {
            self.JCAPPdismissPop()
        } else {
            if self.clickCloseClosure != nil {
                self.clickCloseClosure?(self, false)
            } else {
                self.JCAPPdismissPop(false)
            }
        }
    }
    
    func JCAPPclickConfirmButton(sender: APPActivityButton) {
        self.clickCloseClosure?(self, true)
    }
}

