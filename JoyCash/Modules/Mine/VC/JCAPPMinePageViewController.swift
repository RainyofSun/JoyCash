//
//  JCAPPMinePageViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPMinePageViewController: JCAPPBaseViewController, HideNavigationBarProtocol {

    private lazy var avatarImgView: UIImageView = UIImageView(image: UIImage(named: "mine_avatar"))
    private lazy var phoneLab: UILabel = UILabel.buildJoyCashLabel()
    private lazy var settingBtn: UIButton = UIButton.buildJoyCashImageButton("mine_setting")
    
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
    
    private lazy var subContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        return view
    }()
    
    override func buildViewUI() {
        super.buildViewUI()
        
        self.phoneLab.textAlignment = .left
        
        self.applyBtn.addTarget(self, action: #selector(clickApplyButton(sender: )), for: UIControl.Event.touchUpInside)
        self.repaymentBtn.addTarget(self, action: #selector(clickRepaymentButton(sender: )), for: UIControl.Event.touchUpInside)
        self.finishedBtn.addTarget(self, action: #selector(clickFinishedButton(sender: )), for: UIControl.Event.touchUpInside)
        self.settingBtn.addTarget(self, action: #selector(clickSettingButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.avatarImgView)
        self.contentView.addSubview(self.phoneLab)
        self.contentView.addSubview(self.settingBtn)
        self.contentView.addSubview(self.applyBtn)
        self.contentView.addSubview(self.repaymentBtn)
        self.contentView.addSubview(self.finishedBtn)
        self.contentView.addSubview(self.subContentView)
        
        self.contentView.addMJRefresh(addFooter: false) {[weak self] (isRefresh: Bool) in
            self?.pageNetowrkRequest()
        }
        
        JCAPPPublic.shared.addObserver(self, forKeyPath: LOGIN_OBERVER_KEY, options: .new, context: nil)
    }

    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.avatarImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 5)
            make.top.equalToSuperview().offset(UIDevice.xp_statusBarHeight() + APP_PADDING_UNIT * 10)
        }
        
        self.phoneLab.snp.makeConstraints { make in
            make.left.equalTo(self.avatarImgView.snp.right).offset(APP_PADDING_UNIT * 4)
            make.centerY.equalTo(self.avatarImgView)
        }
        
        self.settingBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.avatarImgView)
            make.right.equalTo(self.subContentView).offset(-APP_PADDING_UNIT * 5)
        }
        
        self.applyBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 3)
            make.top.equalTo(self.avatarImgView.snp.bottom).offset(APP_PADDING_UNIT * 5)
            make.size.equalTo(CGSize(width: (ScreenWidth - APP_PADDING_UNIT * 10)/3, height: 85))
        }
        
        self.repaymentBtn.snp.makeConstraints { make in
            make.left.equalTo(self.applyBtn.snp.right).offset(APP_PADDING_UNIT * 2)
            make.top.size.equalTo(self.applyBtn)
        }
        
        self.finishedBtn.snp.makeConstraints { make in
            make.left.equalTo(self.repaymentBtn.snp.right).offset(APP_PADDING_UNIT * 2)
            make.top.size.equalTo(self.repaymentBtn)
        }
        
        self.subContentView.snp.makeConstraints { make in
            make.left.width.bottom.equalToSuperview()
            make.height.equalTo(ScreenHeight - UIDevice.xp_statusBarHeight() - UIDevice.xp_tabBarFullHeight() - APP_PADDING_UNIT * 38)
            make.top.equalTo(self.applyBtn.snp.bottom).offset(APP_PADDING_UNIT * 5)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.contentView.refresh(begin: true)
    }
    
    override func pageNetowrkRequest() {
        super.pageNetowrkRequest()
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/planar", requestParams: nil)) { [weak self] (task: URLSessionDataTask, res: JCAPPSuccessResponse) in
            self?.contentView.refresh(begin: false)
            guard let _json_dict = res.jsonDict, let _values = _json_dict["physicists"] as? NSArray, let _value_models = NSArray.modelArray(with: JCAPPMineValueModel.self, json: _values) as? [JCAPPMineValueModel] else {
                return
            }
            self?.reloadUserPhone()
            self?.buildMineItem(_value_models)
        } failure: {[weak self] _, _ in
            self?.contentView.refresh(begin: false)
        }
    }
    
    fileprivate func reloadUserPhone() {
        if let _phone = JCAPPPublic.shared.appLoginInfo?.damadian {
            let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paraStyle.paragraphSpacing = APP_PADDING_UNIT
            paraStyle.alignment = .left
            let string: NSMutableAttributedString = NSMutableAttributedString(string: self.replacePhoneNumberWithStar(_phone) + "\n", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#191B1A"), .font: UIFont.boldSystemFont(ofSize: 20)])
            string.append(NSAttributedString(string: "Welcome to the \(Bundle.jk.appDisplayName)！", attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#191B1A"), .font: UIFont.systemFont(ofSize: 12)]))
            self.phoneLab.attributedText = string
        } else {
            self.phoneLab.attributedText = NSAttributedString()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, keyPath == LOGIN_OBERVER_KEY {
            self.reloadUserPhone()
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
    func buildMineItem(_ models: [JCAPPMineValueModel]) {
        if self.subContentView.subviews.count >= 2 {
            return
        }
        
        var temp_item: JCAPPMineActionItem?
        
        models.enumerated().forEach { (idx: Int, item: JCAPPMineValueModel) in
            let _view = JCAPPMineActionItem(frame: CGRectZero)
            _view.setMineActionItemTitle(item.graphic, image: item.like, showLine: idx != (models.count - 1))
            _view.markUrl = item.zeugmatography
            _view.addTarget(self, action: #selector(clickActionItem(sender: )), for: UIControl.Event.touchUpInside)
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
    
    func replacePhoneNumberWithStar(_ phoneNumber: String) -> String {
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
    func clickActionItem(sender: JCAPPMineActionItem) {
        if let _url = sender.markUrl {
            JCAPPPageRouting.shared.JoyCashPageRouter(routeUrl: _url, backToRoot: true)
        }
    }
    
    func clickSettingButton(sender: UIButton) {
        self.navigationController?.pushViewController(JCAPPUserSettingViewController(), animated: true)
    }
    
    func clickApplyButton(sender: UIButton) {
        if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
            _tab.selectedIndex = 1
            if let _nav_vc = _tab.viewControllers?[_tab.selectedIndex] as? JCAPPBaseNavigationController, let _root_vc = _nav_vc.topViewController as? JCAPPCommodityOrderViewController {
                _root_vc.switchOrderMenu(index: 1)
            }
        }
    }
    
    func clickRepaymentButton(sender: UIButton) {
        if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
            _tab.selectedIndex = 1
            if let _nav_vc = _tab.viewControllers?[_tab.selectedIndex] as? JCAPPBaseNavigationController, let _root_vc = _nav_vc.topViewController as? JCAPPCommodityOrderViewController {
                _root_vc.switchOrderMenu(index: 2)
            }
        }
    }
    
    func clickFinishedButton(sender: UIButton) {
        if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
            _tab.selectedIndex = 1
            if let _nav_vc = _tab.viewControllers?[_tab.selectedIndex] as? JCAPPBaseNavigationController, let _root_vc = _nav_vc.topViewController as? JCAPPCommodityOrderViewController {
                _root_vc.switchOrderMenu(index: 3)
            }
        }
    }
}
