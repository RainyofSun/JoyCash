//
//  JCAPPLoanSmallCardTopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

class JCAPPLoanSmallCardTopView: JCAPPCommodityBigCardTopView {

//    private lazy var titleLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.JCAPPgilroyFont(20), labelColor: BLACK_COLOR_26264A)
//    private lazy var bgImgView: UIImageView = UIImageView(image: UIImage(named: "main_top_big_bg"))
//    private lazy var JCAPPamountLab: UILabel = UILabel.JCAPPbuildJoyCashLabel()
//    private lazy var timeBtn: JCAPPTopImgBottomTextButton = JCAPPTopImgBottomTextButton(frame: CGRectZero)
//    private lazy var rateBtn: JCAPPTopImgBottomTextButton = JCAPPTopImgBottomTextButton(frame: CGRectZero)
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.bgImgView.corner(20)
//        
//        self.addSubview(self.logoImgView)
//        self.addSubview(self.titleLab)
//        self.addSubview(self.customerBtn)
//        self.addSubview(self.bgImgView)
//        self.bgImgView.addSubview(self.JCAPPamountLab)
//        self.bgImgView.addSubview(self.timeBtn)
//        self.bgImgView.addSubview(self.rateBtn)
//        
//        self.logoImgView.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 6)
//            make.top.equalToSuperview().offset(UIDevice.app_statusBarAndSafeAreaHeight() + APP_PADDING_UNIT * 5)
//        }
//        
//        self.titleLab.snp.makeConstraints { make in
//            make.left.equalTo(self.logoImgView.snp.right).offset(APP_PADDING_UNIT * 2)
//            make.centerY.equalTo(self.logoImgView)
//        }
//        
//        self.bgImgView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 6)
//            make.top.equalTo(self.logoImgView.snp.bottom).offset(APP_PADDING_UNIT * 4)
//            make.height.equalTo((ScreenWidth - APP_PADDING_UNIT * 6) * 0.71)
//            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
//        }
//        
//        self.JCAPPamountLab.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(APP_PADDING_UNIT * 6)
//            make.width.equalTo(ScreenWidth * 0.8)
//        }
//        
//        self.timeBtn.snp.makeConstraints { make in
//            make.centerX.equalToSuperview().offset(-APP_PADDING_UNIT * 22)
//            make.top.equalTo(self.JCAPPamountLab.snp.bottom).offset(APP_PADDING_UNIT * 4)
//        }
//        
//        self.rateBtn.snp.makeConstraints { make in
//            make.centerX.equalToSuperview().offset(APP_PADDING_UNIT * 22)
//            make.top.equalTo(self.timeBtn)
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    deinit {
//        deallocPrint()
//    }
//    
//    public func JCAPPreloadRecommendCommodity(_ model: VCMainLoanCommodityModel) {
//        self.titleLab.text = model.cavity
//        let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
//        paraStyle.paragraphSpacing = APP_PADDING_UNIT
//        paraStyle.alignment = .center
//        var string: NSMutableAttributedString?
//        if let _title = model.journal {
//            string = NSMutableAttributedString(string: "\(_title)\n", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle])
//        }
//        if let _amount = model.followed {
//            string?.append(NSAttributedString(string: _amount, attributes: [.foregroundColor: UIColor.white, .font: UIFont.JCAPPgilroyFont(64)]))
//        }
//        
//        self.JCAPPamountLab.attributedText = string
//        
//        if let _time = model.tubes, let _time_text = model.projection {
//            let string: NSMutableAttributedString = NSMutableAttributedString(string: _time + "\n", attributes: [.foregroundColor: UIColor.white, .font: UIFont.JCAPPgilroyFont(18)])
//            string.append(NSAttributedString(string: _time_text, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14)]))
//            self.timeBtn.JCAPPsetImage("main_product_day", text: string)
//        }
//        
//        if let _rate = model.dimensions, let _rate_text = model.lauterbur {
//            let string: NSMutableAttributedString = NSMutableAttributedString(string: _rate + "\n", attributes: [.foregroundColor: UIColor.white, .font: UIFont.JCAPPgilroyFont(18)])
//            string.append(NSAttributedString(string: _rate_text, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14)]))
//            self.rateBtn.JCAPPsetImage("main_product_rate", text: string)
//        }
//    }
}
