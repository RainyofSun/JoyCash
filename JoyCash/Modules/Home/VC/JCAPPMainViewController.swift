//
//  JCAPPMainViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPMainViewController: JCAPPBaseViewController, HideNavigationBarProtocol {
    
    private lazy var bigCardTopView: JCAPPCommodityBigCardTopView = JCAPPCommodityBigCardTopView(frame: CGRectZero)
    private lazy var applyBtn: JCAPPLoanApplyButton = JCAPPLoanApplyButton(frame: CGRectZero)
    private lazy var bigCardBottomView: JCAPPLoanBigCardBottomView = JCAPPLoanBigCardBottomView(frame: CGRectZero)
    private lazy var smallCardTopView: JCAPPLoanSmallCardTopView = JCAPPLoanSmallCardTopView(frame: CGRectZero)
    private lazy var smallCardBottomView: JCAPPLoanSmallCardBottomView = JCAPPLoanSmallCardBottomView(frame: CGRectZero)
    
    private var _service_model: JCMainServiceModel?
    private var _loan_model: VCMainLoanCommodityModel?
    
    override func buildViewUI() {
        super.buildViewUI()
    
        self.smallCardBottomView.smallDelegate = self
        self.bigCardBottomView.bidCardDelegate = self
        self.smallCardTopView.customerBtn.addTarget(self, action: #selector(clickCustomerButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.applyBtn.addTarget(self, action: #selector(clickApplyButton(sender: )), for: UIControl.Event.touchUpInside)
        self.contentView.addSubview(self.applyBtn)
        
        self.contentView.addMJRefresh(addFooter: false) {[weak self] (isRefresh: Bool) in
            self?.pageNetowrkRequest()
        }
        
        self.cacheCityRequest()
    }
    
    override func pageNetowrkRequest() {
        super.pageNetowrkRequest()
        // 埋点上报
        self.reloadDeviceLocation()
        JCAPPBuriedPointReport.JCAPPLocationBuryReport()
        JCAPPBuriedPointReport.JCAPPDeviceInfoBuryReport()
        if DeviceAuthorizationTool.authorization().attTrackingStatus() == .authorized {
            JCAPPBuriedPointReport.JCAPPIDFAAndIDFVBuryReport()
        }
        
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/circuit", requestParams: nil)) { [weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            self?.contentView.refresh(begin: false)
            guard let _dict = res.jsonDict, let _main_model = JCAPPLoanCommodityModel.model(withJSON: _dict) else {
                return
            }
            _main_model.filterHomeData()
            
            if let _big_card_model = _main_model.bigCard?.first {
                self?.bigCardTopView.reloadRecommendCommodity(_big_card_model)
                self?._loan_model = _big_card_model
                self?.updateHomeUILayout(true)
                self?.applyBtn.setApplyButtonTitle(_big_card_model.picture)
                if let _marquee = _main_model.peter {
                    self?.bigCardBottomView.reloadMarqueeSource(source: _marquee)
                }
            }
            
            if let _small_card_model = _main_model.smallCard?.first {
                self?.smallCardTopView.reloadRecommendCommodity(_small_card_model)
                self?._loan_model = _small_card_model
                self?.updateHomeUILayout(false)
                self?.applyBtn.setApplyButtonTitle(_small_card_model.picture)
                if let _commodity_models = _main_model.productList {
                    self?.smallCardBottomView.reloadSmallCardCommoditySource(_commodity_models)
                }
            }
            
            self?._service_model = _main_model.like
            
            
        } failure: {[weak self] _, _ in
            self?.contentView.refresh(begin: false)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.contentView.refresh(begin: true)
    }
}

private extension JCAPPMainViewController {
    func cacheCityRequest() {
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/developed", requestParams: nil)) { (task: URLSessionDataTask, res: APPSuccessResponse) in
            guard let _json_dict = res.jsonDict as? NSDictionary, let _json = _json_dict.modelToJSONString() else {
                return
            }
            
            JCAPPLoanCityModel.cacheCityMapJsonToDisk(_json)
        }
    }
    
    func updateHomeUILayout(_ isBig: Bool) {
        self.smallCardTopView.isHidden = isBig
        self.smallCardBottomView.isHidden = isBig
        self.bigCardTopView.isHidden = !isBig
        self.bigCardBottomView.isHidden = !isBig
        self.applyBtn.snp.removeConstraints()
        
        if isBig {
            self.smallCardTopView.snp.removeConstraints()
            self.smallCardBottomView.snp.removeConstraints()
            
            self.contentView.addSubview(self.bigCardTopView)
            self.contentView.addSubview(self.bigCardBottomView)
            
            self.bigCardTopView.snp.makeConstraints { make in
                make.top.left.equalToSuperview()
                make.size.equalTo(CGSize(width: ScreenWidth, height: ScreenWidth * 0.88))
            }
            
            self.applyBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(APP_PADDING_UNIT * 3)
                make.width.equalTo(ScreenWidth - APP_PADDING_UNIT * 6)
                make.top.equalTo(self.bigCardTopView.snp.bottom).offset(APP_PADDING_UNIT * 3)
            }
            
            self.bigCardBottomView.snp.makeConstraints { make in
                make.left.equalTo(self.bigCardTopView)
                make.top.equalTo(self.applyBtn.snp.bottom).offset(APP_PADDING_UNIT * 5)
                make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
            }
            
        } else {
            self.bigCardTopView.snp.removeConstraints()
            self.bigCardBottomView.snp.removeConstraints()
            
            self.contentView.addSubview(self.smallCardTopView)
            self.contentView.addSubview(self.smallCardBottomView)
            
            self.smallCardTopView.snp.makeConstraints { make in
                make.top.left.width.equalToSuperview()
            }
            
            self.applyBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(APP_PADDING_UNIT * 3)
                make.width.equalTo(ScreenWidth - APP_PADDING_UNIT * 6)
                make.top.equalTo(self.smallCardTopView.snp.bottom).offset(APP_PADDING_UNIT * 3)
            }
            
            self.smallCardBottomView.snp.makeConstraints { make in
                make.left.equalTo(self.smallCardTopView)
                make.top.equalTo(self.applyBtn.snp.bottom).offset(APP_PADDING_UNIT * 5)
                make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
                make.width.equalToSuperview()
            }
        }
    }
    
    func gotoCommodityDetail(_ commodityId: String, sender: ActivityAnimationProtocol) {
        guard sender.isEnabled else {
            return
        }
        
        sender.startAnimation()
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/integrated", requestParams: ["overuse": commodityId])) { (task: URLSessionDataTask, res: APPSuccessResponse) in
            sender.stopAnimation()
            guard let _dict = res.jsonDict, let _auth_model = JCAPPLoanAuthModel.model(withJSON: _dict) else {
                return
            }
            
            guard let _url = _auth_model.zeugmatography else {
                return
            }
            
            JCAPPPageRouting.shared.JoyCashPageRouter(routeUrl: _url, backToRoot: true)
            
        } failure: { _, _ in
            sender.stopAnimation()
        }
    }
}

@objc private extension JCAPPMainViewController {
    func clickApplyButton(sender: JCAPPLoanApplyButton) {
        guard let _id = self._loan_model?.mouse else {
            return
        }
        
        self.gotoCommodityDetail(_id, sender: sender)
    }
    
    func clickCustomerButton(sender: UIButton) {
        if let _phone = self._service_model?.developed {
            JKGlobalTools.callPhone(phoneNumber: _phone) { (success: Bool) in
                
            }
        }
    }
}

extension JCAPPMainViewController: APPLoanSmallCardBottomProtocol {
    func didSelectedCommodityModel(_ model: VCMainLoanCommodityModel, sender: APPActivityButton) {
        guard let _id = model.mouse else {
            return
        }
        
        self.gotoCommodityDetail(_id, sender: sender as! ActivityAnimationProtocol)
    }
}

extension JCAPPMainViewController: APPLoanBigCardBottomProtocol {
    func bigCardBottomAction(action: BigCardBottomOperation) {
        switch action {
        case .GotoOrder:
            if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
                _tab.selectedIndex = 1
            }
        case .GotoOrderApply:
            if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
                _tab.selectedIndex = 1
                if let _nav_vc = _tab.viewControllers?[_tab.selectedIndex] as? JCAPPBaseNavigationController, let _root_vc = _nav_vc.topViewController as? JCAPPCommodityOrderViewController {
                    _root_vc.switchOrderMenu(index: 1)
                }
            }
        case .GotoOrderRepayment:
            if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
                _tab.selectedIndex = 1
                if let _nav_vc = _tab.viewControllers?[_tab.selectedIndex] as? JCAPPBaseNavigationController, let _root_vc = _nav_vc.topViewController as? JCAPPCommodityOrderViewController {
                    _root_vc.switchOrderMenu(index: 2)
                }
            }
        case .GotoOrderFinished:
            if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
                _tab.selectedIndex = 1
                if let _nav_vc = _tab.viewControllers?[_tab.selectedIndex] as? JCAPPBaseNavigationController, let _root_vc = _nav_vc.topViewController as? JCAPPCommodityOrderViewController {
                    _root_vc.switchOrderMenu(index: 3)
                }
            }
        case .GotoCertification:
            self.clickApplyButton(sender: self.applyBtn)
        case .GotoCustomerService:
            if let _url = self._service_model?.mansfield {
                JCAPPPageRouting.shared.JoyCashPageRouter(routeUrl: _url, backToRoot: true)
            }
        }
    }
}
