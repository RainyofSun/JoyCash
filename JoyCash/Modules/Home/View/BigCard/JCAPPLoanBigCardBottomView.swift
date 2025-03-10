//
//  JCAPPLoanBigCardBottomView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

enum BigCardBottomOperation {
    case GotoOrder
    case GotoOrderApply
    case GotoOrderRepayment
    case GotoOrderFinished
    case GotoCertification
    case GotoCustomerService
}

protocol APPLoanBigCardBottomProtocol: AnyObject {
    func bigCardBottomAction(action: BigCardBottomOperation)
}

class JCAPPLoanBigCardBottomView: UIView {

    weak open var bidCardDelegate: APPLoanBigCardBottomProtocol?
    
    private lazy var barrageView: GCMarqueeView = {
        let view = GCMarqueeView(frame: CGRect(origin: CGPointZero, size: CGSizeMake(ScreenWidth - APP_PADDING_UNIT * 6, 40)), type: GCMarqueeDirectionType.rtl)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = BLUE_COLOR_4169F6.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var tipLab1: UILabel = UILabel.buildJoyCashLabel(font: UIFont.boldSystemFont(ofSize: 18), labelColor: BLACK_COLOR_26264A, labelText: "Order details")
    private lazy var orderBtn: UIButton = UIButton.buildJoyCashImageButton("main_order_detail")
    
    private lazy var applyBtn: JCAPPTopImgBottomTextButton = {
        let view = JCAPPTopImgBottomTextButton(frame: CGRectZero)
        view.setImage("main_order_apply", text: NSAttributedString(string: "Apply", attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.systemFont(ofSize: 12)]), distance: .zero, bottomDistance: APP_PADDING_UNIT * 3)
        view.backgroundColor = UIColor.hexStringColor(hexString: "#EDF1FF")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var repaymentBtn: JCAPPTopImgBottomTextButton = {
        let view = JCAPPTopImgBottomTextButton(frame: CGRectZero)
        view.setImage("main_order_repayment", text: NSAttributedString(string: "Repayment", attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.systemFont(ofSize: 12)]), distance: .zero, bottomDistance: APP_PADDING_UNIT * 3)
        view.backgroundColor = UIColor.hexStringColor(hexString: "#EDF1FF")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var finishedBtn: JCAPPTopImgBottomTextButton = {
        let view = JCAPPTopImgBottomTextButton(frame: CGRectZero)
        view.setImage("main_order_finished", text: NSAttributedString(string: "Finished", attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.systemFont(ofSize: 12)]), distance: .zero, bottomDistance: APP_PADDING_UNIT * 3)
        view.backgroundColor = UIColor.hexStringColor(hexString: "#EDF1FF")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var serviceContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.init(hexString: "#4169F6")!.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var leftItem: JCAPPLoanBigCardServiceItem = {
        let view = JCAPPLoanBigCardServiceItem(frame: CGRectZero)
        view.setContentIsLeft(isleft: true)
        return view
    }()
    
    private lazy var rightItem: JCAPPLoanBigCardServiceItem = {
        let view = JCAPPLoanBigCardServiceItem(frame: CGRectZero)
        view.setContentIsLeft(isleft: false)
        return view
    }()
    
    private lazy var tipImgView: UIImageView = UIImageView(image: UIImage(named: "main_loan_tip"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.orderBtn.addTarget(self, action: #selector(clickOrderButton(sender: )), for: UIControl.Event.touchUpInside)
        self.applyBtn.addTarget(self, action: #selector(clickApplyButton(sender: )), for: UIControl.Event.touchUpInside)
        self.repaymentBtn.addTarget(self, action: #selector(clickRepaymentButton(sender: )), for: UIControl.Event.touchUpInside)
        self.finishedBtn.addTarget(self, action: #selector(clickFinishedButton(sender: )), for: UIControl.Event.touchUpInside)
        self.leftItem.addTarget(self, action: #selector(clickCertificationButton(sender: )), for: UIControl.Event.touchUpInside)
        self.rightItem.addTarget(self, action: #selector(clickServiceButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.barrageView)
        self.addSubview(self.tipLab1)
        self.addSubview(self.orderBtn)
        self.addSubview(self.applyBtn)
        self.addSubview(self.repaymentBtn)
        self.addSubview(self.finishedBtn)
        self.addSubview(self.serviceContentView)
        self.serviceContentView.addSubview(self.leftItem)
        self.serviceContentView.addSubview(self.rightItem)
        self.addSubview(self.tipImgView)
        
        self.barrageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 3)
            make.top.equalToSuperview().offset(APP_PADDING_UNIT)
            make.size.equalTo(CGSize(width: ScreenWidth - APP_PADDING_UNIT * 6, height: 40))
        }
        
        self.tipLab1.snp.makeConstraints { make in
            make.left.equalTo(self.barrageView)
            make.top.equalTo(self.barrageView.snp.bottom).offset(APP_PADDING_UNIT * 4)
        }
        
        self.orderBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.tipLab1)
            make.right.equalTo(self.barrageView)
        }
        
        self.applyBtn.snp.makeConstraints { make in
            make.left.equalTo(self.barrageView)
            make.top.equalTo(self.tipLab1.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.height.equalTo(85)
        }
        
        self.repaymentBtn.snp.makeConstraints { make in
            make.left.equalTo(self.applyBtn.snp.right).offset(APP_PADDING_UNIT * 2)
            make.top.size.equalTo(self.applyBtn)
        }
        
        self.finishedBtn.snp.makeConstraints { make in
            make.left.equalTo(self.repaymentBtn.snp.right).offset(APP_PADDING_UNIT * 2)
            make.top.size.equalTo(self.repaymentBtn)
            make.right.equalTo(self.barrageView)
        }
        
        self.serviceContentView.snp.makeConstraints { make in
            make.top.equalTo(self.applyBtn.snp.bottom).offset(APP_PADDING_UNIT * 4)
            make.horizontalEdges.equalTo(self.barrageView)
        }
        
        self.leftItem.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 3)
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 3)
        }
        
        self.rightItem.snp.makeConstraints { make in
            make.left.equalTo(self.leftItem.snp.right).offset(APP_PADDING_UNIT * 2)
            make.top.width.equalTo(self.leftItem)
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
        }
        
        self.tipImgView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.serviceContentView)
            make.top.equalTo(self.serviceContentView.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.height.equalTo((ScreenWidth - APP_PADDING_UNIT * 6) * 0.36)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadMarqueeSource(source: [String]) {
        var marqueen_items: [GCMarqueeModel] = []
        
        for str in source {
            var model = GCMarqueeModel(title: str)
            model.itemHeight = 30
            model.bulletBackgroundColor = .clear
            model.titleFont = 14
            model.titleColor = UIColor.init(hexString: "#2C2A32")!
            marqueen_items.append(model)
        }
        
        self.barrageView.items = marqueen_items
    }
}

@objc private extension JCAPPLoanBigCardBottomView {
    func clickOrderButton(sender: UIButton) {
        self.bidCardDelegate?.bigCardBottomAction(action: BigCardBottomOperation.GotoOrder)
    }
    
    func clickApplyButton(sender: UIButton) {
        self.bidCardDelegate?.bigCardBottomAction(action: BigCardBottomOperation.GotoOrderApply)
    }
    
    func clickRepaymentButton(sender: UIButton) {
        self.bidCardDelegate?.bigCardBottomAction(action: BigCardBottomOperation.GotoOrderRepayment)
    }
    
    func clickFinishedButton(sender: UIButton) {
        self.bidCardDelegate?.bigCardBottomAction(action: BigCardBottomOperation.GotoOrderFinished)
    }
    
    func clickCertificationButton(sender: UIButton) {
        self.bidCardDelegate?.bigCardBottomAction(action: BigCardBottomOperation.GotoCertification)
    }
    
    func clickServiceButton(sender: UIButton) {
        self.bidCardDelegate?.bigCardBottomAction(action: BigCardBottomOperation.GotoCustomerService)
    }
}
