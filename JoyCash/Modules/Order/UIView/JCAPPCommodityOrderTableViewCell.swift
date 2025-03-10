//
//  JCAPPCommodityOrderTableViewCell.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

class JCAPPCommodityOrderTableViewCell: UITableViewCell {

    private lazy var gradientView: JCAPPGradientColorView = {
        let view = JCAPPGradientColorView(frame: CGRectZero)
        view.buildGradientWithColors(gradientColors: [UIColor.hexStringColor(hexString: "#DCDDFF"),UIColor.hexStringColor(hexString: "#F1F2FF"),UIColor.hexStringColor(hexString: "#BEC8FF")], gradientStyle: GradientDirectionStyle.leftTopToRightBottom)
        view.corner(20)
        return view
    }()
    
    private lazy var logoImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var titleLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.boldSystemFont(ofSize: 14), labelColor: BLACK_COLOR_26264A)
    private lazy var dotView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.hexStringColor(hexString: "#3C7BE7")
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var stateLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.boldSystemFont(ofSize: 14), labelColor: BLACK_COLOR_26264A)
    private lazy var amountLab: UILabel = UILabel.buildJoyCashLabel()
    private lazy var applyButton: JCAPPActivityButton = JCAPPActivityButton.buildJoyCashGradientLoadingButton("Apply", cornerRadius: 16)
    private lazy var subContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private var protocolItem: JCAPPCommodityInfoItem?
    private var protocol_text: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.logoImgView.corner(5)
        self.amountLab.textAlignment = .left
        
        self.contentView.addSubview(self.gradientView)
        self.gradientView.addSubview(self.logoImgView)
        self.gradientView.addSubview(self.titleLab)
        self.gradientView.addSubview(self.dotView)
        self.gradientView.addSubview(self.stateLab)
        self.gradientView.addSubview(self.amountLab)
        self.gradientView.addSubview(self.applyButton)
        self.gradientView.addSubview(self.subContentView)
        
        self.gradientView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 3)
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 1.5)
        }
        
        self.logoImgView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(APP_PADDING_UNIT * 3)
            make.size.equalTo(32)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.logoImgView)
            make.left.equalTo(self.logoImgView.snp.right).offset(APP_PADDING_UNIT * 2)
        }
        
        self.stateLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
            make.centerY.equalTo(self.titleLab)
        }
        
        self.dotView.snp.makeConstraints { make in
            make.right.equalTo(self.stateLab.snp.left).offset(-APP_PADDING_UNIT * 2)
            make.size.equalTo(8)
            make.centerY.equalTo(self.stateLab)
        }
        
        self.amountLab.snp.makeConstraints { make in
            make.left.equalTo(self.logoImgView)
            make.top.equalTo(self.logoImgView.snp.bottom).offset(APP_PADDING_UNIT * 3)
            make.width.lessThanOrEqualTo(ScreenWidth * 0.5)
        }
        
        self.applyButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.amountLab)
            make.right.equalTo(self.stateLab)
            make.width.greaterThanOrEqualTo(80)
        }
        
        self.subContentView.snp.makeConstraints { make in
            make.top.equalTo(self.amountLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let _protocol_item = self.protocolItem {
            let convertedPoint = convert(point, to: _protocol_item)
            if _protocol_item.point(inside: convertedPoint, with: event) {
                return _protocol_item // 让按钮优先响应事件
            }
        }
        
        return super.hitTest(point, with: event) // 其他情况下调用父类的hitTest方法
    }
    
    public func reloadCommodityCellSource(_ model: JCAPPCommodityOrderModel) {
        if let _textUrl = model.clam, let _url = URL(string: _textUrl) {
            self.logoImgView.setImageWith(_url, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
        
        self.titleLab.text = model.cavity
        self.stateLab.text = model.picture
        
        if let _amount = model.relative, let _text = model.qualitative {
            let string: NSMutableAttributedString = NSMutableAttributedString(string: _text + "\n", attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.systemFont(ofSize: 10)])
            string.append(NSAttributedString(string: _amount, attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.gilroyFont(32)]))
            self.amountLab.attributedText = string
        }
        
        if let _models = model.rapid {
            var showProtocol: Bool = false
            if let _protocol = model.resulted, !_protocol.isEmpty {
                showProtocol = true
                self.protocol_text = model.advent
            }
            self.buildCommodityInfoItem(_models, loanProtocol: showProtocol)
        }
    }
}

private extension JCAPPCommodityOrderTableViewCell {
    func buildCommodityInfoItem(_ models: [JCAPPCommonValueModel], loanProtocol: Bool) {
        self.subContentView.removeAllSubviews()
        
        var _top_temp: JCAPPCommodityInfoItem?
        var _temp_models: [JCAPPCommonValueModel] = models
        if loanProtocol {
            let _protoclMdel: JCAPPCommonValueModel = JCAPPCommonValueModel()
            _protoclMdel.extensive = "Check＞"
            _protoclMdel.graphic = "Loan agreement"
            _temp_models.append(_protoclMdel)
        }
        
        _temp_models.enumerated().forEach { (idx: Int, item: JCAPPCommonValueModel) in
            let view = JCAPPCommodityInfoItem(frame: CGRectZero)
            if loanProtocol && idx == _temp_models.count - 1 {
                view.setInfoItemTitle(item.extensive, value: NSAttributedString(string: item.extensive ?? "", attributes: [.foregroundColor: BLUE_COLOR_4169F6, .font: UIFont.boldSystemFont(ofSize: 14), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: BLUE_COLOR_4169F6]))
                view.addTarget(self, action: #selector(clickProtocol(sender: )), for: UIControl.Event.touchUpInside)
                self.protocolItem = view
            } else {
                view.setInfoItemTitle(item.extensive, value: NSAttributedString(string: item.extensive ?? "", attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.boldSystemFont(ofSize: 14)]))
            }
            
            self.subContentView.addSubview(view)
            
            if let _top = _top_temp {
                if idx == _temp_models.count - 1 {
                    view.snp.makeConstraints { make in
                        make.top.equalTo(_top.snp.bottom)
                        make.horizontalEdges.equalTo(_top)
                        make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 2)
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.top.equalTo(_top.snp.bottom)
                        make.horizontalEdges.equalTo(_top)
                    }
                }
            } else {
                view.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(APP_PADDING_UNIT * 2)
                    make.horizontalEdges.equalToSuperview()
                }
            }
            
            _top_temp = view
        }
    }
}

@objc private extension JCAPPCommodityOrderTableViewCell {
    func clickProtocol(sender: JCAPPCommodityInfoItem) {
        guard let _p_t = protocol_text else {
            return
        }
        
        JCAPPPageRouting.shared.JoyCashPageRouter(routeUrl: _p_t, backToRoot: true)
    }
}
