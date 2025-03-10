//
//  JCAPPCommodityBigCardTopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

class JCAPPCommodityBigCardTopView: UIImageView {

    private lazy var commodityView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.25)
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var commodityLab: UILabel = {
        let view = UILabel.buildJoyCashLabel(font: UIFont.gilroyFont(12), labelColor: UIColor.white)
        view.backgroundColor = .clear
        return view
    }()

    private lazy var amountLab: UILabel = UILabel.buildJoyCashLabel()
    private lazy var timeBtn: JCAPPTopImgBottomTextButton = JCAPPTopImgBottomTextButton(frame: CGRectZero)
    private lazy var rateBtn: JCAPPTopImgBottomTextButton = JCAPPTopImgBottomTextButton(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.image = UIImage(named: "main_top_big_bg")
        self.contentMode = .scaleAspectFill
        
        self.addSubview(self.commodityView)
        self.commodityView.addSubview(self.commodityLab)
        self.addSubview(self.amountLab)
        self.addSubview(self.timeBtn)
        self.addSubview(self.rateBtn)
        
        
        self.commodityView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDevice.xp_statusBarHeight() + APP_PADDING_UNIT * 7)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        
        self.commodityLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
            make.centerY.equalToSuperview()
        }
        
        self.amountLab.snp.makeConstraints { make in
            make.centerX.equalTo(self.commodityLab)
            make.top.equalTo(self.commodityLab.snp.bottom).offset(APP_PADDING_UNIT * 6)
            make.width.equalTo(ScreenWidth * 0.8)
        }
        
        self.timeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-APP_PADDING_UNIT * 20)
            make.top.equalTo(self.amountLab.snp.bottom).offset(APP_PADDING_UNIT * 4)
        }
        
        self.rateBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(APP_PADDING_UNIT * 20)
            make.top.equalTo(self.timeBtn)
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
    
    public func reloadRecommendCommodity(_ model: VCMainLoanCommodityModel) {
        self.commodityLab.text = model.cavity
        let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paraStyle.paragraphSpacing = APP_PADDING_UNIT
        paraStyle.alignment = .center
        var string: NSMutableAttributedString?
        if let _title = model.journal {
            string = NSMutableAttributedString(string: "\(_title)\n", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle])
        }
        if let _amount = model.followed {
            string?.append(NSAttributedString(string: _amount, attributes: [.foregroundColor: UIColor.white, .font: UIFont.gilroyFont(64)]))
        }
        
        self.amountLab.attributedText = string
        
        if let _time = model.tubes, let _time_text = model.projection {
            let string: NSMutableAttributedString = NSMutableAttributedString(string: _time + "\n", attributes: [.foregroundColor: UIColor.white, .font: UIFont.gilroyFont(18)])
            string.append(NSAttributedString(string: _time_text, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14)]))
            self.timeBtn.setImage("main_product_day", text: string)
        }
        
        if let _rate = model.dimensions, let _rate_text = model.lauterbur {
            let string: NSMutableAttributedString = NSMutableAttributedString(string: _rate + "\n", attributes: [.foregroundColor: UIColor.white, .font: UIFont.gilroyFont(18)])
            string.append(NSAttributedString(string: _rate_text, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14)]))
            self.rateBtn.setImage("main_product_rate", text: string)
        }
    }
}
