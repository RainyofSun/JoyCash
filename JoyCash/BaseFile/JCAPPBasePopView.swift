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
    
    private(set) lazy var topImgView: UIImageView = UIImageView(frame: CGRectZero)
    private(set) lazy var popTitleLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.gilroyFont(20), labelColor: BLACK_COLOR_26264A)
    
    private(set) lazy var tipLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.systemFont(ofSize: 14), labelColor: UIColor.hexStringColor(hexString: "#554239", alpha: 0.5))
    
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private(set) lazy var contentView: UIView = UIView(frame: CGRectZero)
    private(set) lazy var confirmBtn: JCAPPActivityButton = JCAPPActivityButton.buildJoyCashGradientLoadingButton("Confirm", cornerRadius: 23)
    
    private lazy var backBtn: UIButton = {
        let view = UIButton.buildJoyCashNormalButton("Back", titleFont: UIFont.systemFont(ofSize: 14), titleColor: UIColor.hexStringColor(hexString: "#554239"))
        view.isHidden = true
        return view
    }()
    
    private lazy var closeBtn: UIButton = {
        let view = UIButton.buildJoyCashImageButton("pop_close")
        view.isHidden = true
        return view
    }()
    
    private var showClose: Bool = false
    
    init(frame: CGRect, showCloseButton show: Bool = false) {
        super.init(frame: frame)
        self.showClose = show
        self.buildPopViews()
        self.layoutPopViews()
    }
    
    deinit {
        deallocPrint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buildPopViews() {
        self.backgroundColor = UIColor.init(white: .zero, alpha: 0.6)
        
        self.popTitleLab.textAlignment = .left
        self.tipLab.textAlignment = .left
        
        self.closeBtn.isHidden = !self.showClose
        self.backBtn.isHidden = self.showClose
        self.topImgView.isHidden = self.showClose
        
        self.closeBtn.addTarget(self, action: #selector(clickCloseButton(sender: )), for: UIControl.Event.touchUpInside)
        self.backBtn.addTarget(self, action: #selector(clickCloseButton(sender: )), for: UIControl.Event.touchUpInside)
        self.confirmBtn.addTarget(self, action: #selector(clickConfirmButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.contentView)
        self.addSubview(self.topImgView)
        self.bgView.addSubview(self.popTitleLab)
        self.bgView.addSubview(self.tipLab)
        self.bgView.addSubview(self.confirmBtn)
        self.bgView.addSubview(self.backBtn)
        self.bgView.addSubview(self.closeBtn)
    }
    
    public func layoutPopViews() {
        self.bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(APP_PADDING_UNIT * 8)
            make.height.greaterThanOrEqualTo(200)
        }
        
        self.topImgView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.bgView)
            make.height.equalTo((ScreenWidth - APP_PADDING_UNIT * 16) * 0.33)
            make.bottom.equalTo(self.bgView.snp.top).offset(APP_PADDING_UNIT * 8)
        }
                
        if self.showClose {
            self.confirmBtn.snp.removeConstraints()
            self.backBtn.snp.removeConstraints()
            
            self.closeBtn.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(APP_PADDING_UNIT * 2)
                make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 2)
            }
            
            self.popTitleLab.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(APP_PADDING_UNIT * 6)
                make.centerX.equalToSuperview()
            }
            
            self.tipLab.snp.makeConstraints { make in
                make.top.equalTo(self.popTitleLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
                make.horizontalEdges.equalTo(self.popTitleLab)
                make.height.greaterThanOrEqualTo(0.1)
            }
            
            self.contentView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.top.equalTo(self.tipLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
                make.height.greaterThanOrEqualTo(250)
            }
            
            self.confirmBtn.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 13)
                make.top.equalTo(self.contentView.snp.bottom).offset(APP_PADDING_UNIT * 2)
                make.height.equalTo(46)
                make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 4)
            }
        } else {
            self.closeBtn.snp.removeConstraints()
            
            self.popTitleLab.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
                make.top.equalTo(self.topImgView.snp.bottom).offset(APP_PADDING_UNIT * 3)
            }
            
            self.tipLab.snp.makeConstraints { make in
                make.top.equalTo(self.popTitleLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
                make.horizontalEdges.equalTo(self.popTitleLab)
                make.height.greaterThanOrEqualTo(0.1)
            }
            
            self.contentView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.top.equalTo(self.tipLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
                make.height.greaterThanOrEqualTo(1)
            }
            
            self.confirmBtn.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 13)
                make.top.equalTo(self.contentView.snp.bottom).offset(APP_PADDING_UNIT * 2)
                make.height.equalTo(46)
            }
            
            self.backBtn.snp.makeConstraints { make in
                make.horizontalEdges.height.equalTo(self.confirmBtn)
                make.top.equalTo(self.confirmBtn.snp.bottom).offset(APP_PADDING_UNIT * 3)
                make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 4)
            }
        }
    }
    
    public class func convenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
        let view = JCAPPBasePopView(frame: UIScreen.main.bounds, showCloseButton: show)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
    
    public func dismissPop(_ needCall: Bool = true) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = .zero
        } completion: { _ in
            if needCall {
                self.popDidmissClosure?(self)
            }
            self.removeFromSuperview()
        }
    }
    
    public func resetConfirmTitle(_ title: String, backTitle: String? = nil) {
        self.confirmBtn.setTitle(title, for: UIControl.State.normal)
        if let _b = backTitle {
            self.backBtn.setTitle(_b, for: UIControl.State.normal)
        }
    }
}

@objc extension JCAPPBasePopView {
    func clickCloseButton(sender: UIButton) {
        if sender == self.closeBtn {
            self.dismissPop()
        } else {
            if self.clickCloseClosure != nil {
                self.clickCloseClosure?(self, false)
            } else {
                self.dismissPop(false)
            }
        }
    }
    
    func clickConfirmButton(sender: JCAPPActivityButton) {
        self.clickCloseClosure?(self, true)
    }
}

