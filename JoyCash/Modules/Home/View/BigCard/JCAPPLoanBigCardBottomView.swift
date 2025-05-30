//
//  JCAPPLoanBigCardBottomView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

enum JCAPPBigCardBottomOperation {
    case GotoOrder
    case GotoOrderApply
    case GotoOrderRepayment
    case GotoOrderFinished
    case GotoCertification
    case GotoCustomerService
}

protocol APPLoanBigCardBottomProtocol: AnyObject {
    func JCAPPbigCardBottomAction(action: JCAPPBigCardBottomOperation)
}

class JCAPPLoanBigCardBottomView: UIView {

    weak open var bidCardDelegate: APPLoanBigCardBottomProtocol?
    
    private lazy var JCAPPserviceContentView: UIImageView = UIImageView(image: UIImage(named: "h_bottom_ooo"))
    private lazy var tipImgView: UIImageView = UIImageView(image: UIImage(named: "main_loan_tip"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.JCAPPserviceContentView)
        self.addSubview(self.tipImgView)
        
        self.JCAPPserviceContentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.size.equalTo(CGSize(width: ScreenWidth - APP_PADDING_UNIT * 8, height: (ScreenWidth - APP_PADDING_UNIT * 8) * 0.82))
        }
        
        self.tipImgView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.JCAPPserviceContentView)
            make.top.equalTo(self.JCAPPserviceContentView.snp.bottom).offset(APP_PADDING_UNIT * 3)
            make.height.equalTo((ScreenWidth - APP_PADDING_UNIT * 8) * 0.38)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}
