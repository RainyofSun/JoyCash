//
//  JCAPPLoanSmallCardTableViewCell.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

class JCAPPLoanSmallCardTableViewCell: UITableViewCell {

    private lazy var gradientBgView: JCAPPGradientColorView = {
        let view = JCAPPGradientColorView(frame: CGRectZero)
        view.buildGradientWithColors(gradientColors: [UIColor.hexStringColor(hexString: "#DCDDFF"), UIColor.hexStringColor(hexString: "#F1F2FF"), UIColor.hexStringColor(hexString: "#BEC8FF")], gradientStyle: GradientDirectionStyle.leftTopToRightBottom)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var logoImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var titleLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.systemFont(ofSize: 14), labelColor: BLACK_COLOR_26264A)
    private(set) lazy var loanBtn: JCAPPActivityButton = JCAPPActivityButton.buildJoyCashGradientLoadingButton("", cornerRadius: 16)
    private lazy var subContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var amountLab: UILabel = UILabel.buildJoyCashLabel()
    private lazy var timeLab: UILabel = UILabel.buildJoyCashLabel()
    private lazy var rateLab: UILabel = UILabel.buildJoyCashLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.loanBtn.isUserInteractionEnabled = false
        self.logoImgView.corner(4)
        
        self.contentView.addSubview(self.gradientBgView)
        self.gradientBgView.addSubview(self.logoImgView)
        self.gradientBgView.addSubview(self.titleLab)
        self.gradientBgView.addSubview(self.loanBtn)
        self.gradientBgView.addSubview(self.subContentView)
        self.subContentView.addSubview(self.amountLab)
        self.subContentView.addSubview(self.rateLab)
        self.subContentView.addSubview(self.timeLab)
        
        self.gradientBgView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT)
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 3)
            make.width.equalTo(ScreenWidth - APP_PADDING_UNIT * 12)
        }
        
        self.logoImgView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(APP_PADDING_UNIT * 3)
            make.size.equalTo(32)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.logoImgView)
            make.left.equalTo(self.logoImgView.snp.right).offset(APP_PADDING_UNIT * 2)
        }
        
        self.loanBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLab)
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
            make.size.equalTo(CGSize(width: 80, height: 32))
        }
        
        self.subContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT)
            make.top.equalTo(self.logoImgView.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
        }
        
        self.amountLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
        }
        
        self.rateLab.snp.makeConstraints { make in
            make.left.equalTo(self.amountLab.snp.right)
            make.top.width.equalTo(self.amountLab)
        }
        
        self.timeLab.snp.makeConstraints { make in
            make.left.equalTo(self.rateLab.snp.right)
            make.top.width.equalTo(self.rateLab)
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deallocPrint()
    }
    
    public func reloadRecommendCommodity(_ model: VCMainLoanCommodityModel) {
        self.titleLab.text = model.cavity
        self.loanBtn.setTitle(model.picture, for: UIControl.State.normal)
        
        if let _text = model.clam, let _url = URL(string: _text) {
            self.logoImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
        
        let parastyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        parastyle.paragraphSpacing = APP_PADDING_UNIT * 3
        parastyle.alignment = .center
        
        if let _amount = model.followed {
            
            let tempStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(_amount)\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#202020"), .font: UIFont.gilroyFont(18), .paragraphStyle: parastyle])
            if let _title = model.journal {
                let string = NSAttributedString(string: "\(_title)", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#A998AA"), .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: parastyle])
                tempStr.append(string)
            }
            self.amountLab.attributedText = tempStr
        }
        
        if let _time = model.tubes, let _time_text = model.projection {
            let string: NSMutableAttributedString = NSMutableAttributedString(string: _time + "\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#202020"), .font: UIFont.gilroyFont(18), .paragraphStyle: parastyle])
            string.append(NSAttributedString(string: _time_text, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#A998AA"), .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: parastyle]))
            self.timeLab.attributedText = string
        }
        
        if let _rate = model.alterations, let _rate_text = model.lauterbur {
            let string: NSMutableAttributedString = NSMutableAttributedString(string: _rate + "\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#202020"), .font: UIFont.gilroyFont(18), .paragraphStyle: parastyle])
            string.append(NSAttributedString(string: _rate_text, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#A998AA"), .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: parastyle]))
            self.rateLab.attributedText = string
        }
    }
}
