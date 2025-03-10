//
//  JCAPPLoanBigCardServiceItem.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

class JCAPPLoanBigCardServiceItem: UIControl {

    private lazy var content: UILabel = UILabel.buildJoyCashLabel()
    private lazy var arrowImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var rightImgView: UIImageView = UIImageView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.content)
        self.addSubview(self.arrowImgView)
        self.addSubview(self.rightImgView)
        
        self.content.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(APP_PADDING_UNIT)
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 3)
//            make.height.greaterThanOrEqualTo(90)
        }
        
        self.arrowImgView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 3)
            make.size.equalTo(24)
            make.top.equalTo(self.content.snp.bottom).offset(APP_PADDING_UNIT * 3)
        }
        
        self.rightImgView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContentIsLeft(isleft: Bool) {
        let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paraStyle.paragraphSpacing = APP_PADDING_UNIT
        paraStyle.lineBreakMode = .byWordWrapping
        if isleft {
            self.backgroundColor = UIColor.init(hexString: "#FFEEE0")!
            let string: NSMutableAttributedString = NSMutableAttributedString(string: "Quick certification\n", attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.gilroyFont(15), .paragraphStyle: paraStyle])
            string.append(NSAttributedString(string: "You can get the loan amount after certification", attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle]))
            self.content.attributedText = string
            self.arrowImgView.image = UIImage(named: "main_quick_loan_arrow")
            self.rightImgView.image = UIImage(named: "main_quick_loan")
        } else {
            self.backgroundColor = UIColor.init(hexString: "#EDF1FF")!
            let string: NSMutableAttributedString = NSMutableAttributedString(string: "Customer service\n", attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.gilroyFont(15), .paragraphStyle: paraStyle])
            string.append(NSAttributedString(string: "If you have any questions, please contact us", attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle]))
            self.content.attributedText = string
            self.arrowImgView.image = UIImage(named: "main_quick_service_arrow")
            self.rightImgView.image = UIImage(named: "main_quick_service")
        }
    }
}
