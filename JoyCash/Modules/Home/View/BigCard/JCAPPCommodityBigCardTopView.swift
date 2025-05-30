//
//  JCAPPCommodityBigCardTopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

class JCAPPCommodityBigCardTopView: UIImageView {
    
    open var touchControlClosure: ((JCAPPCommodityBigCardTopView, JCAPPLoanApplyButton) -> Void)?
    
    private lazy var JCAPPcommodityLab: UILabel = {
        let view = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.JCAPPgilroyFont(12), labelColor: UIColor.white)
        view.backgroundColor = .clear
        view.textAlignment = .left
        return view
    }()

    private lazy var JCAPPamountLab: UILabel = UILabel.JCAPPbuildJoyCashLabel()
    private lazy var JCAPPtimeBtn: JCAPPLeftImageRightTextButton = JCAPPLeftImageRightTextButton(frame: CGRectZero)
    private lazy var JCAPPrateBtn: JCAPPLeftImageRightTextButton = JCAPPLeftImageRightTextButton(frame: CGRectZero)
    private(set) lazy var JCAPPapplyBtn: JCAPPLoanApplyButton = JCAPPLoanApplyButton(frame: CGRectZero)
    private(set) lazy var JCAPPBControl: UIControl = UIControl(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.image = UIImage(named: "main_top_big_bg")
        self.contentMode = .scaleAspectFill
        
        self.JCAPPBControl.addTarget(self, action: #selector(JCAPPClickBottomControl(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.JCAPPBControl)
        self.addSubview(self.JCAPPcommodityLab)
        self.addSubview(self.JCAPPamountLab)
        self.addSubview(self.JCAPPtimeBtn)
        self.addSubview(self.JCAPPrateBtn)
        self.addSubview(self.JCAPPapplyBtn)
        
        self.JCAPPBControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.JCAPPcommodityLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDevice.app_statusBarAndSafeAreaHeight() + APP_PADDING_UNIT)
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.height.greaterThanOrEqualTo(55)
        }
        
        self.JCAPPamountLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.JCAPPcommodityLab.snp.bottom).offset(APP_PADDING_UNIT * 18)
            make.width.equalTo(ScreenWidth * 0.8)
        }
        
        self.JCAPPtimeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-APP_PADDING_UNIT * 20)
            make.top.equalTo(self.JCAPPamountLab.snp.bottom).offset(APP_PADDING_UNIT * 8)
        }
        
        self.JCAPPrateBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(APP_PADDING_UNIT * 20)
            make.top.equalTo(self.JCAPPtimeBtn)
        }
        
        self.JCAPPapplyBtn.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 8)
            make.top.equalTo(self.JCAPPtimeBtn.snp.bottom).offset(APP_PADDING_UNIT * 9)
            make.size.equalTo(CGSize(width: ScreenWidth - APP_PADDING_UNIT * 16, height: (ScreenWidth - APP_PADDING_UNIT * 16) * 0.245))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.bounds == .zero {
            return
        }
        
        self.jk.addCorner(conrners: [.bottomLeft, .bottomRight], radius: 20)
    }
    
    deinit {
        deallocPrint()
    }
    
    public func JCAPPreloadRecommendCommodity(_ model: VCMainLoanCommodityModel) {
        let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paraStyle.paragraphSpacing = APP_PADDING_UNIT
        paraStyle.alignment = .left
        
        if let _p_name = model.cavity {
            let mutleString: NSMutableAttributedString = NSMutableAttributedString(string: "\(_p_name)\n", attributes: [.font: UIFont.JCAPPDDINRegularFont(20), .foregroundColor: UIColor.white, .paragraphStyle: paraStyle])
            mutleString.append(NSAttributedString(string: String.JCAPP_euiskdlasldString(), attributes: [.font: UIFont.JCAPPDDINBoldFont(28), .foregroundColor: UIColor.white, .paragraphStyle: paraStyle]))
            self.JCAPPcommodityLab.attributedText = mutleString
        }
        
        let paraStyle1: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paraStyle1.paragraphSpacing = APP_PADDING_UNIT
        paraStyle1.alignment = .center
        var string: NSMutableAttributedString?
        if let _title = model.journal {
            string = NSMutableAttributedString(string: "\(_title)\n", attributes: [.foregroundColor: JCAPP_GROWN_COLOR_5F4631, .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle1])
        }
        if let _amount = model.followed {
            string?.append(NSAttributedString(string: _amount, attributes: [.foregroundColor: JCAPP_GROWN_COLOR_5F4631, .font: UIFont.JCAPPDDINBoldFont(64)]))
        }
        
        self.JCAPPamountLab.attributedText = string
        
        if let _time = model.tubes, let _time_text = model.projection {
            let string: NSMutableAttributedString = NSMutableAttributedString(string: _time + "\n", attributes: [.foregroundColor: JCAPP_GROWN_COLOR_5F4631, .font: UIFont.JCAPPDDINBoldFont(18)])
            string.append(NSAttributedString(string: _time_text, attributes: [.foregroundColor: JCAPP_GROWN_COLOR_5F4631, .font: UIFont.systemFont(ofSize: 14)]))
            self.JCAPPtimeBtn.JCAPPsetImage("main_product_day", text: string)
        }
        
        if let _rate = model.dimensions, let _rate_text = model.lauterbur {
            let string: NSMutableAttributedString = NSMutableAttributedString(string: _rate + "\n", attributes: [.foregroundColor: JCAPP_GROWN_COLOR_5F4631, .font: UIFont.JCAPPDDINBoldFont(18)])
            string.append(NSAttributedString(string: _rate_text, attributes: [.foregroundColor: JCAPP_GROWN_COLOR_5F4631, .font: UIFont.systemFont(ofSize: 14)]))
            self.JCAPPrateBtn.JCAPPsetImage("main_product_rate", text: string)
        }
    }
}

@objc extension JCAPPCommodityBigCardTopView {
    func JCAPPClickBottomControl(sender: UIControl) {
        self.touchControlClosure?(self, self.JCAPPapplyBtn)
    }
}
