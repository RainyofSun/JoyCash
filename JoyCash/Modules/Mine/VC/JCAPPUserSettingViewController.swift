//
//  JCAPPUserSettingViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPUserSettingViewController: JCAPPBaseViewController {

    private lazy var subContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var versionItem: JCAPPMineActionItem = JCAPPMineActionItem(frame: CGRectZero)
    private lazy var cancelItem: JCAPPMineActionItem = JCAPPMineActionItem(frame: CGRectZero)
    private lazy var logoutItem: JCAPPMineActionItem = JCAPPMineActionItem(frame: CGRectZero)
    
    private var request_url = ""
    
    override func buildViewUI() {
        super.buildViewUI()
        self.title = "Setting"
        
        self.versionItem.setMineActionItemTitleShowVersion("Version", image: "mine_version", showLine: true)
        self.cancelItem.setMineActionItemTitle("Account cancellation", image: "mine_cacnel", showLine: true)
        self.logoutItem.setMineActionItemTitle("Exit", image: "mine_logout", showLine: false)
        
        self.cancelItem.addTarget(self, action: #selector(clickActionItem(sender: )), for: UIControl.Event.touchUpInside)
        self.logoutItem.addTarget(self, action: #selector(clickActionItem(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.subContentView)
        self.subContentView.addSubview(self.versionItem)
        self.subContentView.addSubview(self.cancelItem)
        self.subContentView.addSubview(self.logoutItem)
    }

    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.subContentView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.width.equalTo(ScreenWidth - APP_PADDING_UNIT * 8)
        }
        
        self.versionItem.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        self.cancelItem.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.versionItem.snp.bottom)
        }
        
        self.logoutItem.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(self.cancelItem.snp.bottom)
        }
    }
    
    override func pageNetowrkRequest() {
        super.pageNetowrkRequest()
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig(self.request_url, requestParams: nil)) { [weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            JCAPPPublic.shared.deleteLocalLoginInfo()
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}

@objc private extension JCAPPUserSettingViewController {
    func clickActionItem(sender: JCAPPMineActionItem) {
        
        if sender == self.cancelItem {
            self.request_url = "said/late"
            JCAPPMineCancelPopView.convenienceShowPop(self.view).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
                guard let _p_view = popView as? JCAPPMineCancelPopView else {
                    return
                }
                
                if !isConfirm {
                    guard _p_view.protocolView.hasSelected else {
                        self?.view.makeToast("Please confirm whether you agree to loan agreement")
                        return
                    }
                    
                    _p_view.dismissPop()
                    self?.pageNetowrkRequest()
                } else {
                    _p_view.dismissPop()
                }
            }
        }
        
        if sender == self.logoutItem {
            self.request_url = "said/damaging"
            JCAPPMineLogoutPopView.convenienceShowPop(self.view).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
                if !isConfirm {
                    self?.pageNetowrkRequest()
                } else {
                    popView.dismissPop()
                }
            }
        }
    }
}
