//
//  JCAPPCommodityInfoItem.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

class JCAPPCommodityInfoItem: UIControl {

    private lazy var JCAPPleftLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.systemFont(ofSize: 14), labelColor: UIColor.hexStringColor(hexString: "#26264A", alpha: 0.75))
    private lazy var JCAPPrightLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.boldSystemFont(ofSize: 14), labelColor: BLACK_COLOR_26264A)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.JCAPPleftLab)
        self.addSubview(self.JCAPPrightLab)
        
        self.JCAPPleftLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT)
            make.height.equalTo(20)
        }
        
        self.JCAPPrightLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func JCAPPsetInfoItemTitle(_ title: String?, value: NSAttributedString) {
        self.JCAPPleftLab.text = title
        self.JCAPPrightLab.attributedText = value
    }
}
