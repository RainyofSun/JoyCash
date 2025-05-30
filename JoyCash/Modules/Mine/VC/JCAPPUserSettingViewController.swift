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
    
    private lazy var JCAPPversionItem: JCAPPMineActionItem = JCAPPMineActionItem(frame: CGRectZero)
    private lazy var JCAPPcancelItem: JCAPPMineActionItem = JCAPPMineActionItem(frame: CGRectZero)
    private lazy var JCAPPlogoutItem: JCAPPMineActionItem = JCAPPMineActionItem(frame: CGRectZero)
    
    private var request_url = ""
    
    override func JCAPPbuildViewUI() {
        super.JCAPPbuildViewUI()
        self.title = "Setting"
        
        self.JCAPPversionItem.JCAPPsetMineActionItemTitleShowVersion(String.JCAPP_nxsjskdsllString(), image: "mine_version")
        self.JCAPPcancelItem.JCAPPsetMineActionItemTitle(String.JCAPP_mmlslkdlasdString(), image: "mine_cacnel")
        self.JCAPPlogoutItem.JCAPPsetMineActionItemTitle(String.JCAPP_zzsdjaskjdiwodpdlString(), image: "mine_logout")
        
        self.JCAPPcancelItem.addTarget(self, action: #selector(JCAPPclickActionItem(sender: )), for: UIControl.Event.touchUpInside)
        self.JCAPPlogoutItem.addTarget(self, action: #selector(JCAPPclickActionItem(sender: )), for: UIControl.Event.touchUpInside)
        
        self.JCAPPcontentView.addSubview(self.subContentView)
        self.subContentView.addSubview(self.JCAPPversionItem)
        self.subContentView.addSubview(self.JCAPPcancelItem)
        self.subContentView.addSubview(self.JCAPPlogoutItem)
    }

    override func JCAPPlayoutControlViews() {
        super.JCAPPlayoutControlViews()
        
        self.subContentView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.width.equalTo(ScreenWidth - APP_PADDING_UNIT * 8)
        }
        
        self.JCAPPversionItem.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        self.JCAPPcancelItem.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.JCAPPversionItem.snp.bottom)
        }
        
        self.JCAPPlogoutItem.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(self.JCAPPcancelItem.snp.bottom)
        }
    }
    
    override func JCAPPpageNetowrkRequest() {
        super.JCAPPpageNetowrkRequest()
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig(self.request_url, requestParams: nil)) { [weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            JCAPPPublic.shared.JCAPPdeleteLocalLoginInfo()
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}

@objc private extension JCAPPUserSettingViewController {
    func JCAPPclickActionItem(sender: JCAPPMineActionItem) {
        
        if sender == self.JCAPPcancelItem {
            self.request_url = "said/late"
            JCAPPMineCancelPopView.JCAPPconvenienceShowPop(self.view).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
                guard let _p_view = popView as? JCAPPMineCancelPopView else {
                    return
                }
                
                if !isConfirm {
                    guard _p_view.JCAPPprotocolView.hasSelected else {
                        self?.view.makeToast("Please confirm whether you agree to loan agreement")
                        return
                    }
                    
                    _p_view.JCAPPdismissPop()
                    self?.JCAPPpageNetowrkRequest()
                } else {
                    _p_view.JCAPPdismissPop()
                }
            }
        }
        
        if sender == self.JCAPPlogoutItem {
            self.request_url = "said/damaging"
            JCAPPMineLogoutPopView.JCAPPconvenienceShowPop(self.view).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
                if !isConfirm {
                    self?.JCAPPpageNetowrkRequest()
                } else {
                    popView.JCAPPdismissPop()
                }
            }
        }
    }
}
