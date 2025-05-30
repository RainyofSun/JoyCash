//
//  JCAPPMinePageViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPMinePageViewController: JCAPPBaseViewController, HideNavigationBarProtocol {

    private lazy var avatarImgView: UIImageView = UIImageView(image: UIImage(named: "mine_avatar"))
    private lazy var phoneLab: UILabel = UILabel.JCAPPbuildJoyCashLabel()
    
    private lazy var JCAPPapplyBtn: JCAPPTopImgBottomTextButton = {
        let view = JCAPPTopImgBottomTextButton(frame: CGRectZero)
        view.JCAPPsetImage("main_order_apply", text: NSAttributedString(string: "Apply", attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.systemFont(ofSize: 12)]), distance: .zero, bottomDistance: APP_PADDING_UNIT * 3)
        view.backgroundColor = UIColor.hexStringColor(hexString: "#EDF1FF")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var JCAPPrepaymentBtn: JCAPPTopImgBottomTextButton = {
        let view = JCAPPTopImgBottomTextButton(frame: CGRectZero)
        view.JCAPPsetImage("main_order_repayment", text: NSAttributedString(string: "Repayment", attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.systemFont(ofSize: 12)]), distance: .zero, bottomDistance: APP_PADDING_UNIT * 3)
        view.backgroundColor = UIColor.hexStringColor(hexString: "#EDF1FF")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var JCAPPfinishedBtn: JCAPPTopImgBottomTextButton = {
        let view = JCAPPTopImgBottomTextButton(frame: CGRectZero)
        view.JCAPPsetImage("main_order_finished", text: NSAttributedString(string: "Finished", attributes: [.foregroundColor: BLACK_COLOR_26264A, .font: UIFont.systemFont(ofSize: 12)]), distance: .zero, bottomDistance: APP_PADDING_UNIT * 3)
        view.backgroundColor = UIColor.hexStringColor(hexString: "#EDF1FF")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var subContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var JCAPPconfirationStatusBtn: UIButton = {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.setBackgroundImage(UIImage(named: "mine_confiration_uncomplete"), for: UIControl.State.normal)
        view.setBackgroundImage(UIImage(named: "mine_confiration_complete"), for: UIControl.State.selected)
        view.adjustsImageWhenDisabled = false
        return view
    }()
    
    override func JCAPPbuildViewUI() {
        super.JCAPPbuildViewUI()
        
        self.phoneLab.textAlignment = .left
        
        self.JCAPPconfirationStatusBtn.isSelected = JCAPPPublic.shared.JCAPPAuthIsComplete()
        
        self.JCAPPapplyBtn.addTarget(self, action: #selector(JCAPPclickApplyButton(sender: )), for: UIControl.Event.touchUpInside)
        self.JCAPPrepaymentBtn.addTarget(self, action: #selector(JCAPPclickRepaymentButton(sender: )), for: UIControl.Event.touchUpInside)
        self.JCAPPfinishedBtn.addTarget(self, action: #selector(JCAPPclickFinishedButton(sender: )), for: UIControl.Event.touchUpInside)
        self.JCAPPconfirationStatusBtn.addTarget(self, action: #selector(JCAPPClickComfirationStatusButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.JCAPPcontentView.addSubview(self.avatarImgView)
        self.JCAPPcontentView.addSubview(self.phoneLab)
        self.JCAPPcontentView.addSubview(self.JCAPPapplyBtn)
        self.JCAPPcontentView.addSubview(self.JCAPPrepaymentBtn)
        self.JCAPPcontentView.addSubview(self.JCAPPfinishedBtn)
        self.JCAPPcontentView.addSubview(self.JCAPPconfirationStatusBtn)
        self.JCAPPcontentView.addSubview(self.subContentView)
        
        self.JCAPPcontentView.addMJRefresh(addFooter: false) {[weak self] (isRefresh: Bool) in
            self?.JCAPPpageNetowrkRequest()
        }
        
        JCAPPPublic.shared.addObserver(self, forKeyPath: LOGIN_OBERVER_KEY, options: .new, context: nil)
    }

    override func JCAPPlayoutControlViews() {
        super.JCAPPlayoutControlViews()
        
        self.avatarImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 5)
            make.top.equalToSuperview().offset(UIDevice.app_statusBarAndSafeAreaHeight() + APP_PADDING_UNIT * 10)
        }
        
        self.phoneLab.snp.makeConstraints { make in
            make.left.equalTo(self.avatarImgView.snp.right).offset(APP_PADDING_UNIT * 4)
            make.centerY.equalTo(self.avatarImgView)
        }
        
        self.JCAPPapplyBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 3)
            make.top.equalTo(self.avatarImgView.snp.bottom).offset(APP_PADDING_UNIT * 5)
            make.size.equalTo(CGSize(width: (ScreenWidth - APP_PADDING_UNIT * 10)/3, height: 85))
        }
        
        self.JCAPPrepaymentBtn.snp.makeConstraints { make in
            make.left.equalTo(self.JCAPPapplyBtn.snp.right).offset(APP_PADDING_UNIT * 2)
            make.top.size.equalTo(self.JCAPPapplyBtn)
        }
        
        self.JCAPPfinishedBtn.snp.makeConstraints { make in
            make.left.equalTo(self.JCAPPrepaymentBtn.snp.right).offset(APP_PADDING_UNIT * 2)
            make.top.size.equalTo(self.JCAPPrepaymentBtn)
        }
        
        self.JCAPPconfirationStatusBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.JCAPPapplyBtn.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.size.equalTo(CGSize(width: ScreenWidth - APP_PADDING_UNIT * 8, height: (ScreenWidth - APP_PADDING_UNIT * 8) * 0.43))
        }
        
        self.subContentView.snp.makeConstraints { make in
            make.left.width.bottom.equalToSuperview()
            make.height.equalTo(ScreenHeight - UIDevice.app_statusBarAndSafeAreaHeight() - UIDevice.app_tabbarAndSafeAreaHeight() - APP_PADDING_UNIT * 38 - (ScreenWidth - APP_PADDING_UNIT * 8) * 0.43)
            make.top.equalTo(self.JCAPPconfirationStatusBtn.snp.bottom).offset(APP_PADDING_UNIT * 5)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.JCAPPcontentView.refresh(begin: true)
    }
    
    override func JCAPPpageNetowrkRequest() {
        super.JCAPPpageNetowrkRequest()
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/planar", requestParams: nil)) { [weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            self?.JCAPPcontentView.refresh(begin: false)
            guard let _json_dict = res.jsonDict, let _values = _json_dict["physicists"] as? NSArray, let _value_models = NSArray.modelArray(with: JCAPPMineValueModel.self, json: _values) as? [JCAPPMineValueModel] else {
                return
            }
            self?.JCAPPreloadUserPhone()
            self?.JCAPPbuildMineItem(_value_models)
        } failure: {[weak self] _, _ in
            self?.JCAPPcontentView.refresh(begin: false)
        }
    }
    
    fileprivate func JCAPPreloadUserPhone() {
        if let _phone = JCAPPPublic.shared.appLoginInfo?.damadian {
            let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paraStyle.paragraphSpacing = APP_PADDING_UNIT
            paraStyle.alignment = .left
            let string: NSMutableAttributedString = NSMutableAttributedString(string: self.JCAPPreplacePhoneNumberWithStar(_phone) + "\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#191B1A"), .font: UIFont.boldSystemFont(ofSize: 20)])
            string.append(NSAttributedString(string: String.JCAPP_xxskdaslsopldjdlString(), attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#191B1A"), .font: UIFont.systemFont(ofSize: 12)]))
            self.phoneLab.attributedText = string
        } else {
            self.phoneLab.attributedText = NSAttributedString()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, keyPath == LOGIN_OBERVER_KEY {
            self.JCAPPreloadUserPhone()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.subContentView.bounds == .zero {
            return
        }
        
        let maskPath = UIBezierPath(roundedRect: self.subContentView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.subContentView.bounds
        maskLayer.path = maskPath.cgPath
        self.subContentView.layer.mask = maskLayer
    }
}

private extension JCAPPMinePageViewController {
    func JCAPPbuildMineItem(_ models: [JCAPPMineValueModel]) {
        self.subContentView.subviews.forEach { (element: UIView) in
            if element is JCAPPMineActionItem {
                element.removeFromSuperview()
            }
        }
        
        var temp_item: JCAPPMineActionItem?
        
        models.enumerated().forEach { (idx: Int, item: JCAPPMineValueModel) in
            let _view = JCAPPMineActionItem(frame: CGRectZero)
            _view.JCAPPsetMineActionItemTitle(item.graphic, image: item.like)
            _view.markUrl = item.zeugmatography
            _view.addTarget(self, action: #selector(JCAPPclickActionItem(sender: )), for: UIControl.Event.touchUpInside)
            self.subContentView.addSubview(_view)
            
            if let _top = temp_item {
                _view.snp.makeConstraints { make in
                    make.horizontalEdges.equalTo(_top)
                    make.top.equalTo(_top.snp.bottom)
                }
            } else {
                _view.snp.makeConstraints { make in
                    make.top.horizontalEdges.equalToSuperview()
                }
            }
            
            temp_item = _view
        }
    }
    
    func JCAPPreplacePhoneNumberWithStar(_ phoneNumber: String) -> String {
        let phoneLength = phoneNumber.count
        let startIndex = phoneNumber.startIndex
        let left: Int = 2
        let right: Int = 4
        let endIndex = phoneNumber.index(startIndex, offsetBy: left)
        let endIndex2 = phoneNumber.index(startIndex, offsetBy: phoneLength - right)
        var str: String = " "
        let length = phoneLength - left - right
        for count in 0...length {
            str += "*"
            if count == length {
                str += " "
            }
        }
        
        let maskedNumber = phoneNumber.replacingCharacters(in: endIndex..<endIndex2, with: str)
        
        return maskedNumber
    }
}

@objc private extension JCAPPMinePageViewController {
    func JCAPPclickActionItem(sender: JCAPPMineActionItem) {
        if let _url = sender.markUrl {
            JCAPPPageRouting.shared.JCAPPJoyCashPageRouter(routeUrl: _url, backToRoot: true)
        }
    }
    
    func JCAPPclickApplyButton(sender: UIButton) {
        if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
            _tab.selectedIndex = 1
            if let _nav_vc = _tab.viewControllers?[_tab.selectedIndex] as? JCAPPBaseNavigationController, let _root_vc = _nav_vc.topViewController as? JCAPPCommodityOrderViewController {
                _root_vc.JCAPPswitchOrderMenu(index: 1)
            }
        }
    }
    
    func JCAPPclickRepaymentButton(sender: UIButton) {
        if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
            _tab.selectedIndex = 1
            if let _nav_vc = _tab.viewControllers?[_tab.selectedIndex] as? JCAPPBaseNavigationController, let _root_vc = _nav_vc.topViewController as? JCAPPCommodityOrderViewController {
                _root_vc.JCAPPswitchOrderMenu(index: 2)
            }
        }
    }
    
    func JCAPPclickFinishedButton(sender: UIButton) {
        if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
            _tab.selectedIndex = 1
            if let _nav_vc = _tab.viewControllers?[_tab.selectedIndex] as? JCAPPBaseNavigationController, let _root_vc = _nav_vc.topViewController as? JCAPPCommodityOrderViewController {
                _root_vc.JCAPPswitchOrderMenu(index: 3)
            }
        }
    }
    
    func JCAPPClickComfirationStatusButton(sender: UIButton) {
        guard sender.isEnabled, let _c_id = JCAPPPublic.shared.home_commodity_id else {
            return
        }
        
        sender.isEnabled = false
        
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/integrated", requestParams: ["overuse": _c_id])) { (task: URLSessionDataTask, res: APPSuccessResponse) in
            guard let _dict = res.jsonDict, let _auth_model = JCAPPLoanAuthModel.model(withJSON: _dict) else {
                return
            }
            
            guard let _url = _auth_model.zeugmatography else {
                return
            }
            
            JCAPPPageRouting.shared.JCAPPJoyCashPageRouter(routeUrl: _url, backToRoot: true)
            
        } failure: { _, _ in
            sender.isEnabled = true
        }
    }
}
