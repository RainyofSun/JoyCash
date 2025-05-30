//
//  JCAPPLoanSmallCardTableViewCell.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

class JCAPPLoanSmallCardTableViewCell: UITableViewCell {

    private lazy var JCAPPgradientBgView: GradientColorView = {
        let view = GradientColorView(frame: CGRectZero)
        view.buildGradientWithColors(gradientColors: [UIColor.hexStringColor(hexString: "#FFECDC"), UIColor.hexStringColor(hexString: "#FFF7F1"), UIColor.hexStringColor(hexString: "#FFD3BE")], gradientStyle: GradientDirectionStyle.leftTopToRightBottom)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var logoImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var JCAPPtitleLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.systemFont(ofSize: 14), labelColor: BLACK_COLOR_26264A)
    private(set) lazy var JCAPPloanBtn: APPActivityButton = APPActivityButton.JCAPPbuildJoyCashGradientLoadingButton("", cornerRadius: 16)
    private lazy var JCAPPsubContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var JCAPPamountLab: UILabel = UILabel.JCAPPbuildJoyCashLabel()
    private lazy var JCAPPtimeLab: UILabel = UILabel.JCAPPbuildJoyCashLabel()
    private lazy var JCAPPrateLab: UILabel = UILabel.JCAPPbuildJoyCashLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.JCAPPloanBtn.isUserInteractionEnabled = false
        self.logoImgView.corner(4)
        
        self.contentView.addSubview(self.JCAPPgradientBgView)
        self.JCAPPgradientBgView.addSubview(self.logoImgView)
        self.JCAPPgradientBgView.addSubview(self.JCAPPtitleLab)
        self.JCAPPgradientBgView.addSubview(self.JCAPPloanBtn)
        self.JCAPPgradientBgView.addSubview(self.JCAPPsubContentView)
        self.JCAPPsubContentView.addSubview(self.JCAPPamountLab)
        self.JCAPPsubContentView.addSubview(self.JCAPPrateLab)
        self.JCAPPsubContentView.addSubview(self.JCAPPtimeLab)
        
        self.JCAPPgradientBgView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT)
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 2)
            make.width.equalTo(ScreenWidth - APP_PADDING_UNIT * 10)
        }
        
        self.logoImgView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(APP_PADDING_UNIT * 3)
            make.size.equalTo(32)
        }
        
        self.JCAPPtitleLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.logoImgView)
            make.left.equalTo(self.logoImgView.snp.right).offset(APP_PADDING_UNIT * 2)
        }
        
        self.JCAPPloanBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.JCAPPtitleLab)
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
            make.size.equalTo(CGSize(width: 80, height: 32))
        }
        
        self.JCAPPsubContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT)
            make.top.equalTo(self.logoImgView.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
        }
        
        self.JCAPPamountLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
        }
        
        self.JCAPPrateLab.snp.makeConstraints { make in
            make.left.equalTo(self.JCAPPamountLab.snp.right)
            make.top.width.equalTo(self.JCAPPamountLab)
        }
        
        self.JCAPPtimeLab.snp.makeConstraints { make in
            make.left.equalTo(self.JCAPPrateLab.snp.right)
            make.top.width.equalTo(self.JCAPPrateLab)
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deallocPrint()
    }
    
    public func JCAPPreloadRecommendCommodity(_ model: VCMainLoanCommodityModel) {
        self.JCAPPtitleLab.text = model.cavity
        self.JCAPPloanBtn.setTitle(model.picture, for: UIControl.State.normal)
        
        if let _text = model.clam, let _url = URL(string: _text) {
            self.logoImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
        
        let parastyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        parastyle.paragraphSpacing = APP_PADDING_UNIT * 3
        parastyle.alignment = .center
        
        if let _amount = model.followed {
            
            let tempStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(_amount)\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#202020"), .font: UIFont.JCAPPgilroyFont(18), .paragraphStyle: parastyle])
            if let _title = model.journal {
                let string = NSAttributedString(string: "\(_title)", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#A998AA"), .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: parastyle])
                tempStr.append(string)
            }
            self.JCAPPamountLab.attributedText = tempStr
        }
        
        if let _time = model.tubes, let _time_text = model.projection {
            let string: NSMutableAttributedString = NSMutableAttributedString(string: _time + "\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#202020"), .font: UIFont.JCAPPgilroyFont(18), .paragraphStyle: parastyle])
            string.append(NSAttributedString(string: _time_text, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#A998AA"), .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: parastyle]))
            self.JCAPPtimeLab.attributedText = string
        }
        
        if let _rate = model.alterations, let _rate_text = model.lauterbur {
            let string: NSMutableAttributedString = NSMutableAttributedString(string: _rate + "\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#202020"), .font: UIFont.JCAPPgilroyFont(18), .paragraphStyle: parastyle])
            string.append(NSAttributedString(string: _rate_text, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#A998AA"), .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: parastyle]))
            self.JCAPPrateLab.attributedText = string
        }
    }
}
