//
//  JCAPPCommodityViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPCommodityViewController: JCAPPBaseViewController, HideNavigationBarProtocol {

    private lazy var backBtn: UIButton = UIButton.buildJoyCashImageButton("certification_back")
    private lazy var titleLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.systemFont(ofSize: 17), labelColor: UIColor.white, labelText: "Certification")
    private lazy var topBgImgView: UIImageView = UIImageView(image: UIImage(named: "certification_top_bg"))
    private lazy var protocolView: JCAPPProtocolView = JCAPPProtocolView(frame: CGRectZero)
    private lazy var loanBtn: JCAPPActivityButton = JCAPPActivityButton.buildJoyCashGradientLoadingButton("Loan Now", cornerRadius: 23)
    
    private var id_number: String?
    private var amount_info: (amount: String?, term: String?, termType: String?)
    private var _protocol_url: String?
    private var _wait_auth_model: JCAPPWaitCertificationModel?
    private var isRefresh: Bool = false
    
    init(withCommodityIDNumber idNumber: String) {
        super.init(nibName: nil, bundle: nil)
        self.id_number = idNumber
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        
        self.protocolView.protocolDelegate = self
        self.protocolView.isHidden = true
        
        self.backBtn.addTarget(self, action: #selector(clickBackButton(sender: )), for: UIControl.Event.touchUpInside)
        self.loanBtn.addTarget(self, action: #selector(clickLoanNowButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(self.topBgImgView)
        self.view.addSubview(self.backBtn)
        self.view.addSubview(self.titleLab)
        self.view.addSubview(self.protocolView)
        self.view.addSubview(loanBtn)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.top.equalToSuperview().offset(UIDevice.xp_statusBarHeight() + APP_PADDING_UNIT * 3)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.backBtn)
        }
        
        self.topBgImgView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(ScreenWidth * 0.55)
        }
        
        self.contentView.snp.remakeConstraints { make in
            make.top.equalTo(self.topBgImgView.snp.bottom).offset(APP_PADDING_UNIT * 4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.protocolView.snp.top).offset(-APP_PADDING_UNIT * 4)
        }
        
        self.protocolView.snp.makeConstraints { make in
            make.left.equalTo(self.loanBtn)
            make.bottom.equalTo(self.loanBtn.snp.top).offset(-APP_PADDING_UNIT * 3)
            make.width.lessThanOrEqualTo(ScreenWidth - APP_PADDING_UNIT * 18)
        }
        
        self.loanBtn.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 12)
            make.bottom.equalToSuperview().offset(-UIDevice.xp_tabBarFullHeight() - APP_PADDING_UNIT * 2)
            make.height.equalTo(46)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pageNetowrkRequest() {
        super.pageNetowrkRequest()
        guard let _p_id = self.id_number else {
            return
        }
        
        self.isRefresh = true
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/transistors", requestParams: ["overuse": _p_id])) {[weak self] (task: URLSessionDataTask, res: JCAPPSuccessResponse) in
            self?.isRefresh = false
            guard let _dict = res.jsonDict, let _commodity_model = JCAPPCommodityCertificationModel.model(withJSON: _dict) else {
                return
            }
            
            if let _p_model = _commodity_model.hyperacusis {
                self?.loanBtn.setTitle(_p_model.picture, for: UIControl.State.normal)
                // 记录产品ID/订单号
                JCAPPPublic.shared.productID = _p_model.mouse
                JCAPPPublic.shared.productOrderNum = _p_model.fatalities
                self?.amount_info = (_p_model.hearing, _p_model.speeds, "\(_p_model.powerful)")
            }
            
            if let _loan_protocol = _commodity_model.chemicals?.graphic, !_loan_protocol.isEmpty {
                self?._protocol_url = _commodity_model.chemicals?.done
                self?.protocolView.isHidden = false
                self?.protocolView.setProtocol(_loan_protocol, defaultSelected: true)
            }
            
            if let _certification_models = _commodity_model.peripheral {
                self?.buildComodityAuthItems(_certification_models)
            }
            
            self?._wait_auth_model = _commodity_model.generally
        } failure: {[weak self] _, _ in
            self?.isRefresh = false
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.pageNetowrkRequest()
    }
}

private extension JCAPPCommodityViewController {
    func buildComodityAuthItems(_ model: [JCAPPAuthorizationModel]) {
        self.contentView.subviews.forEach { (item: UIView) in
            if item is JCAPPCommodityCertificationItem {
                item.removeFromSuperview()
            }
        }
        
        var temp_top: JCAPPCommodityCertificationItem?
        
        model.enumerated().forEach { (idx: Int, item: JCAPPAuthorizationModel) in
            let view = JCAPPCommodityCertificationItem(frame: CGRectZero)
            view.reloadAuthItem(item)
            view.addTarget(self, action: #selector(clickAuthItem(sender: )), for: UIControl.Event.touchUpInside)
            self.contentView.addSubview(view)
            
            if let _top = temp_top {
                if idx == model.count - 1 {
                    view.snp.makeConstraints { make in
                        make.horizontalEdges.equalTo(_top)
                        make.top.equalTo(_top.snp.bottom).offset(APP_PADDING_UNIT * 2)
                        make.bottom.equalToSuperview()
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.horizontalEdges.equalTo(_top)
                        make.top.equalTo(_top.snp.bottom).offset(APP_PADDING_UNIT * 2)
                    }
                }
            } else {
                view.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(APP_PADDING_UNIT * 4)
                    make.top.equalToSuperview()
                    make.width.equalTo(ScreenWidth - APP_PADDING_UNIT * 8)
                }
            }
            
            temp_top = view
        }
    }
    
    func gotoCommodityAuthItem(_ certificationType: JCAPPCertificationType, h5Url: String? = nil, certificationTitle: String?) {
        
        if let _url = h5Url, !_url.isEmpty {
            JCAPPPageRouting.shared.JoyCashPageRouter(routeUrl: _url)
        } else {
            switch certificationType {
            case .Certification_ID_Card:
                self.navigationController?.pushViewController(JCAPPIDCardViewController(certificationTitle: certificationTitle), animated: true)
            case .Certification_Personal_Info:
                self.navigationController?.pushViewController(JCAPPAuthInfoViewController(certificationTitle: certificationTitle, infoStyle: AuthInfoStyle.PersonalInfo), animated: true)
            case .Certification_Job_Info:
                self.navigationController?.pushViewController(JCAPPAuthInfoViewController(certificationTitle: certificationTitle, infoStyle: AuthInfoStyle.WorkingInfo), animated: true)
            case .Certification_Contects:
                self.navigationController?.pushViewController(JCAPPContactsViewController(certificationTitle: certificationTitle), animated: true)
            case .Certification_BankCard:
                self.navigationController?.pushViewController(JCAPPAuthInfoViewController(certificationTitle: certificationTitle, infoStyle: AuthInfoStyle.BankCard), animated: true)
            }
        }
    }
}

extension JCAPPCommodityViewController: APPProtocolDelegate {
    func gotoProtocol() {
        guard let _url = self._protocol_url else {
            return
        }
        
        JCAPPPageRouting.shared.JoyCashPageRouter(routeUrl: _url, backToRoot: true)
    }
}

@objc private extension JCAPPCommodityViewController {
    func clickBackButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func clickAuthItem(sender: JCAPPCommodityCertificationItem) {
        guard let _a_model = sender.authModel else {
            return
        }
        
        // 正在刷新时,不进入认证
        if self.isRefresh {
            return
        }
        
        var c_type: JCAPPCertificationType = _a_model.certificationType
        var title: String? = _a_model.graphic
        var _h5_url: String? = _a_model.zeugmatography
        
        // 如果有待认证项,优先跳转到待认证
        if !_a_model.protocols, let _wait_c_type = self._wait_auth_model?.certificationType {
            c_type = _wait_c_type
            title = self._wait_auth_model?.graphic
            _h5_url = self._wait_auth_model?.zeugmatography
        }
        
        self.gotoCommodityAuthItem(c_type, h5Url: _h5_url, certificationTitle: title)
    }
    
    func clickLoanNowButton(sender: JCAPPActivityButton) {
        // 正在刷新时,不进入认证
        if self.isRefresh {
            return
        }
        
        // 如果有待认证项,优先跳转到待认证
        if let _wait_c_type = self._wait_auth_model?.certificationType {
            self.gotoCommodityAuthItem(_wait_c_type, h5Url: self._wait_auth_model?.zeugmatography, certificationTitle: self._wait_auth_model?.graphic)
            return
        }
        
        if !self.protocolView.isHidden && !self.protocolView.hasSelected {
            self.view.makeToast("Please read and agree to the agreement")
            return
        }
        
        sender.startAnimation()
        self.buryBeginTime = Date().jk.dateToTimeStamp()
        // 重新获取位置信息
        self.reloadDeviceLocation()
        
        guard let _order_num = JCAPPPublic.shared.productOrderNum else {
            return
        }
        
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/damadian", requestParams: ["hearing": self.amount_info.amount ?? "", "trimesters": _order_num, "speeds": self.amount_info.term ?? "", "powerful": self.amount_info.termType ?? ""])) { [weak self] (task: URLSessionDataTask, res: JCAPPSuccessResponse) in
            sender.stopAnimation()
            guard let _dict = res.jsonDict, let _model = JCAPPAuthJumpModel.model(withJSON: _dict) else {
                return
            }
            
            if let _url = _model.zeugmatography {
                JCAPPPageRouting.shared.JoyCashPageRouter(routeUrl: _url, backToRoot: _url.hasPrefix("http"))
            }
            
            // 埋点
            JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCRiskControlPointsType.JC_APP_BeginLoanApply, beginTime: self?.buryBeginTime, endTime: Date().jk.dateToTimeStamp(), orderNum: _order_num)
        } failure: { _, _ in
            sender.stopAnimation()
        }
    }
}
