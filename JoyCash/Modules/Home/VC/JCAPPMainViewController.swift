//
//  JCAPPMainViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPMainViewController: JCAPPBaseViewController, HideNavigationBarProtocol {
    
    private lazy var JCAPPbigCardTopView: JCAPPCommodityBigCardTopView = JCAPPCommodityBigCardTopView(frame: CGRectZero)
    private lazy var JCAPPbigCardBottomView: JCAPPLoanBigCardBottomView = JCAPPLoanBigCardBottomView(frame: CGRectZero)
    private lazy var JCAPPsmallCardTopView: JCAPPLoanSmallCardTopView = JCAPPLoanSmallCardTopView(frame: CGRectZero)
    private lazy var JCAPPsmallCardBottomView: JCAPPLoanSmallCardBottomView = JCAPPLoanSmallCardBottomView(frame: CGRectZero)
    
    private var JCAPP_service_model: JCMainServiceModel?
    private var JCAPP_loan_model: VCMainLoanCommodityModel?
    
    private var JCAPPIsJuming: Bool = false
    
    override func JCAPPbuildViewUI() {
        super.JCAPPbuildViewUI()
    
        self.JCAPPgradientView.buildGradientWithColors(gradientColors: [UIColor.init(hexString: "#EF4C2C")!, UIColor.init(hexString: "#FA7A4F")!])
        
        self.JCAPPsmallCardBottomView.smallDelegate = self
        self.JCAPPbigCardBottomView.bidCardDelegate = self
        
        self.JCAPPbigCardTopView.JCAPPapplyBtn.addTarget(self, action: #selector(JCAPPclickApplyButton(sender: )), for: UIControl.Event.touchUpInside)
        self.JCAPPsmallCardTopView.JCAPPapplyBtn.addTarget(self, action: #selector(JCAPPclickApplyButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.JCAPPbigCardTopView.touchControlClosure = {[weak self] (view: JCAPPCommodityBigCardTopView, btn: JCAPPLoanApplyButton) in
            self?.JCAPPclickApplyButton(sender: btn)
        }
        
        self.JCAPPsmallCardTopView.touchControlClosure = {[weak self] (view: JCAPPCommodityBigCardTopView, btn: JCAPPLoanApplyButton) in
            self?.JCAPPclickApplyButton(sender: btn)
        }
        
        self.JCAPPcontentView.addMJRefresh(addFooter: false) {[weak self] (isRefresh: Bool) in
            self?.JCAPPpageNetowrkRequest()
        }
        
        self.JCAPPcacheCityRequest()
    }
    
    override func JCAPPpageNetowrkRequest() {
        super.JCAPPpageNetowrkRequest()
        // 埋点上报
        self.JCAPPreloadDeviceLocation()
        JCAPPBuriedPointReport.JCAPPLocationBuryReport()
        JCAPPBuriedPointReport.JCAPPDeviceInfoBuryReport()
        if DeviceAuthorizationTool.authorization().attTrackingStatus() == .authorized {
            JCAPPBuriedPointReport.JCAPPIDFAAndIDFVBuryReport()
        }
        
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/circuit", requestParams: nil)) { [weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            self?.JCAPPcontentView.refresh(begin: false)
            guard let _dict = res.jsonDict, let _main_model = JCAPPLoanCommodityModel.model(withJSON: _dict) else {
                return
            }
            _main_model.filterHomeData()
            
            if let _big_card_model = _main_model.bigCard?.first {
                self?.JCAPPbigCardTopView.JCAPPreloadRecommendCommodity(_big_card_model)
                self?.JCAPP_loan_model = _big_card_model
                self?.JCAPPupdateHomeUILayout(true)
                self?.JCAPPbigCardTopView.JCAPPapplyBtn.JCAPPsetApplyButtonTitle(_big_card_model.picture)
                JCAPPPublic.shared.home_commodity_id = _big_card_model.mouse;
            }
            
            if let _small_card_model = _main_model.smallCard?.first {
                self?.JCAPPsmallCardTopView.JCAPPapplyBtn.JCAPPsetApplyButtonTitle(_small_card_model.picture)
                self?.JCAPPsmallCardTopView.JCAPPreloadRecommendCommodity(_small_card_model)
                self?.JCAPP_loan_model = _small_card_model
                self?.JCAPPupdateHomeUILayout(false)
                self?.JCAPPbigCardTopView.JCAPPapplyBtn.JCAPPsetApplyButtonTitle(_small_card_model.picture)
                if let _commodity_models = _main_model.productList {
                    self?.JCAPPsmallCardBottomView.JCAPPreloadSmallCardCommoditySource(_commodity_models)
                }
                JCAPPPublic.shared.home_commodity_id = _small_card_model.mouse;
            }
            
            self?.JCAPP_service_model = _main_model.like
            
            
        } failure: {[weak self] _, _ in
            self?.JCAPPcontentView.refresh(begin: false)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.JCAPPcontentView.refresh(begin: true)
    }
}

private extension JCAPPMainViewController {
    func JCAPPcacheCityRequest() {
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/developed", requestParams: nil)) { (task: URLSessionDataTask, res: APPSuccessResponse) in
            guard let _json_dict = res.jsonDict as? NSDictionary, let _json = _json_dict.modelToJSONString() else {
                return
            }
            
            JCAPPLoanCityModel.cacheCityMapJsonToDisk(_json)
        }
    }
    
    func JCAPPupdateHomeUILayout(_ isBig: Bool) {
        self.JCAPPsmallCardTopView.isHidden = isBig
        self.JCAPPsmallCardBottomView.isHidden = isBig
        self.JCAPPbigCardTopView.isHidden = !isBig
        self.JCAPPbigCardBottomView.isHidden = !isBig
        
        if isBig {
            self.JCAPPsmallCardTopView.snp.removeConstraints()
            self.JCAPPsmallCardBottomView.snp.removeConstraints()
            
            self.JCAPPcontentView.addSubview(self.JCAPPbigCardTopView)
            self.JCAPPcontentView.addSubview(self.JCAPPbigCardBottomView)
            
            self.JCAPPbigCardTopView.snp.makeConstraints { make in
                make.top.left.equalToSuperview()
                make.size.equalTo(CGSize(width: ScreenWidth, height: ScreenWidth * 1.2))
            }
            
            self.JCAPPbigCardBottomView.snp.makeConstraints { make in
                make.left.equalTo(self.JCAPPbigCardTopView)
                make.top.equalTo(self.JCAPPbigCardTopView.snp.bottom).offset(APP_PADDING_UNIT * 3)
                make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
            }
            
        } else {
            self.JCAPPbigCardTopView.snp.removeConstraints()
            self.JCAPPbigCardBottomView.snp.removeConstraints()
            
            self.JCAPPcontentView.addSubview(self.JCAPPsmallCardTopView)
            self.JCAPPcontentView.addSubview(self.JCAPPsmallCardBottomView)
            
            self.JCAPPsmallCardTopView.snp.makeConstraints { make in
                make.top.left.equalToSuperview()
                make.size.equalTo(CGSize(width: ScreenWidth, height: ScreenWidth * 1.2))
            }
            
            self.JCAPPsmallCardBottomView.snp.makeConstraints { make in
                make.left.equalTo(self.JCAPPsmallCardTopView)
                make.top.equalTo(self.JCAPPsmallCardTopView.snp.bottom).offset(APP_PADDING_UNIT * 3)
                make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
                make.width.equalToSuperview()
            }
        }
    }
    
    func JCAPPgotoCommodityDetail(_ commodityId: String, sender: ActivityAnimationProtocol) {
        guard !JCAPPIsJuming else {
            APPCocoaLog.debug("拦截进入消息 --------------")
            return
        }
        
        if JCAPPPublic.shared.showPositionAlert && APPInfomationCache.todayShouldShowLocationAlert() {
            // 弹出定位授权弹窗
            self.showSystemStyleSettingAlert(String.JCAPP_yshxksmwklxString(), okTitle: nil, cancelTitle: nil)
            return
        }
        
        guard sender.isEnabled else {
            // 防止多次点入
            return
        }
        
        JCAPPIsJuming = true
        sender.startAnimation()
        
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/integrated", requestParams: ["overuse": commodityId])) {[weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            sender.stopAnimation()
            self?.JCAPPIsJuming = false
            
            guard let _dict = res.jsonDict, let _auth_model = JCAPPLoanAuthModel.model(withJSON: _dict) else {
                return
            }
            
            guard let _url = _auth_model.zeugmatography else {
                return
            }
            
            JCAPPPageRouting.shared.JCAPPJoyCashPageRouter(routeUrl: _url, backToRoot: true)
            
        } failure: { [weak self] _, _ in
            sender.stopAnimation()
            self?.JCAPPIsJuming = false
        }
    }
}

@objc private extension JCAPPMainViewController {
    func JCAPPclickApplyButton(sender: JCAPPLoanApplyButton) {
        guard let _id = self.JCAPP_loan_model?.mouse else {
            return
        }
        
        self.JCAPPgotoCommodityDetail(_id, sender: sender)
    }
}

extension JCAPPMainViewController: APPLoanSmallCardBottomProtocol {
    func JCAPPdidSelectedCommodityModel(_ model: VCMainLoanCommodityModel, sender: APPActivityButton) {
        guard let _id = model.mouse else {
            return
        }
        
        self.JCAPPgotoCommodityDetail(_id, sender: sender as ActivityAnimationProtocol)
    }
}

extension JCAPPMainViewController: APPLoanBigCardBottomProtocol {
    func JCAPPbigCardBottomAction(action: JCAPPBigCardBottomOperation) {
        switch action {
        case .GotoOrder:
            if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
                _tab.selectedIndex = 1
            }
        case .GotoOrderApply:
            if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
                _tab.selectedIndex = 1
                if let _nav_vc = _tab.viewControllers?[_tab.selectedIndex] as? JCAPPBaseNavigationController, let _root_vc = _nav_vc.topViewController as? JCAPPCommodityOrderViewController {
                    _root_vc.JCAPPswitchOrderMenu(index: 1)
                }
            }
        case .GotoOrderRepayment:
            if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
                _tab.selectedIndex = 1
                if let _nav_vc = _tab.viewControllers?[_tab.selectedIndex] as? JCAPPBaseNavigationController, let _root_vc = _nav_vc.topViewController as? JCAPPCommodityOrderViewController {
                    _root_vc.JCAPPswitchOrderMenu(index: 2)
                }
            }
        case .GotoOrderFinished:
            if let _tab = self.tabBarController as? JCAPPBaseTabBarController {
                _tab.selectedIndex = 1
                if let _nav_vc = _tab.viewControllers?[_tab.selectedIndex] as? JCAPPBaseNavigationController, let _root_vc = _nav_vc.topViewController as? JCAPPCommodityOrderViewController {
                    _root_vc.JCAPPswitchOrderMenu(index: 3)
                }
            }
        case .GotoCertification:
            self.JCAPPclickApplyButton(sender: self.JCAPPbigCardTopView.JCAPPapplyBtn)
        case .GotoCustomerService:
            if let _url = self.JCAPP_service_model?.mansfield {
                JCAPPPageRouting.shared.JCAPPJoyCashPageRouter(routeUrl: _url, backToRoot: true)
            }
        }
    }
}
