//
//  JCAPPAuthInfoViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit

enum JCAPPAuthInfoStyle {
    case PersonalInfo
    case WorkingInfo
    case BankCard
}

class JCAPPAuthInfoViewController: JCAPPCommodityAuthViewController {

    private var JCAPPrequest_tupe: (requestUrl: String, saveUrl: String, riskType: JCAPPRiskControlPointsType)?
    private var JCAPPtitle_tupe: (title: String, subTitle: String)?
    private var JCAPPrequestParams: NSMutableDictionary = NSMutableDictionary()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRectZero)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private var _sub_height: CGFloat = 20
    
    init(certificationTitle title: String?, infoStyle style: JCAPPAuthInfoStyle) {
        super.init(certificationTitle: title)
        switch style {
        case .PersonalInfo:
            self.JCAPPrequest_tupe = ("said/practical", "said/crucial", .JC_APP_PersonalInfo)
            self.JCAPPtitle_tupe = (String.JCAPP_jjdjswkkString(), String.JCAPP_hhsejjsjncsString())
        case .WorkingInfo:
            self.JCAPPrequest_tupe = ("said/quick", "said/manual", .JC_APP_WorkingInfo)
            self.JCAPPtitle_tupe = (String.JCAPP_erkfkjdskString(), String.JCAPP_rtsykdilksString())
        case .BankCard:
            self.JCAPPrequest_tupe = ("said/built", "said/incorporated", .JC_APP_BindingBankCard)
            self.JCAPPtitle_tupe = (String.JCAPP_ujwjlejducnString(), String.JCAPP_rusikdslpString())
        }
        
        guard let _sub = self.JCAPPtitle_tupe?.subTitle else {
            return
        }
        
        self._sub_height = _sub.jk.heightAccording(width: ScreenWidth - APP_PADDING_UNIT * 14, font: UIFont.systemFont(ofSize: 12))
    }
    
    override func JCAPPbuildViewUI() {
        super.JCAPPbuildViewUI()
        if let _tupe = self.JCAPPtitle_tupe {
            self.JCAPPsetTipWithTitle(_tupe.title, subTitle: _tupe.subTitle)
        }
        
        self.JCAPPcontainerView.addSubview(self.scrollView)
    }
    
    override func JCAPPlayoutControlViews() {
        super.JCAPPlayoutControlViews()
        
        self.JCAPPcontentLab.snp.removeConstraints()
        self.JCAPPcontentLab.snp.remakeConstraints { make in
            make.top.equalTo(self.JCAPPtitleLab.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.horizontalEdges.equalTo(self.JCAPPtitleLab)
            make.height.equalTo(self._sub_height)
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.JCAPPcontentLab.snp.bottom).offset(APP_PADDING_UNIT * 5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(ScreenHeight - UIDevice.app_navigationBarAndStatusBarHeight() - UIDevice.app_safeDistanceBottom() - APP_PADDING_UNIT * 38 - self._sub_height)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func JCAPPpageNetowrkRequest() {
        super.JCAPPpageNetowrkRequest()
        
        guard let _p_id = JCAPPPublic.shared.productID, let _tupe = self.JCAPPrequest_tupe else {
            return
        }
        
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig(_tupe.requestUrl, requestParams: ["overuse": _p_id])) {[weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            guard let _json_dict = res.jsonDict, let _json_array = _json_dict["befored"] as? NSArray, let _json_models = NSArray.modelArray(with: JCAPPAuthInfoUnitModel.self, json: _json_array) as? [JCAPPAuthInfoUnitModel] else {
                return
            }
            
            self?.JCAPPbuildUnitInfoViews(_json_models)
        }
    }
    
    override func JCAPPclickNextButton(sender: APPActivityButton) {
        guard let _p_id = JCAPPPublic.shared.productID, let _tupe = self.JCAPPrequest_tupe else {
            return
        }
        
        self.JCAPPrequestParams.setValue(_p_id, forKey: "overuse")
        APPCocoaLog.debug("------ \n\(self.JCAPPrequestParams)\n -------")
        sender.startAnimation()
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig(_tupe.saveUrl, requestParams: self.JCAPPrequestParams as? [String : String])) {[weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            sender.stopAnimation()
            // 埋点
            JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: _tupe.riskType, beginTime: self?.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
            self?.navigationController?.popViewController(animated: true)
        } failure: { _, _ in
            sender.stopAnimation()
        }
    }
}

private extension JCAPPAuthInfoViewController {
    func JCAPPbuildUnitInfoViews(_ models: [JCAPPAuthInfoUnitModel]) {
        var _temp_top: JCAPPAuthCardInfoUnitView?
        
        models.enumerated().forEach { (idx: Int, item: JCAPPAuthInfoUnitModel) in
            let view = JCAPPAuthCardInfoUnitView(frame: CGRectZero)
            view.JCAPPsetInfoUnitModel(item, unitRightImage: UIImage(named: "pop_down_arrow"))
            view.unitDelegate = self
            self.scrollView.addSubview(view)
            if let _back = item.video, let _k = item.prize {
                self.JCAPPrequestParams.setValue(_back, forKey: _k)
            }
            
            if let _top = _temp_top {
                if idx == models.count - 1 {
                    view.snp.makeConstraints { make in
                        make.left.size.equalTo(_top)
                        make.top.equalTo(_top.snp.bottom).offset(APP_PADDING_UNIT * 4)
                        make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 4)
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.left.size.equalTo(_top)
                        make.top.equalTo(_top.snp.bottom).offset(APP_PADDING_UNIT * 4)
                    }
                }
            } else {
                view.snp.makeConstraints { make in
                    make.horizontalEdges.equalTo(self.view).inset(APP_PADDING_UNIT * 4)
                    make.top.equalToSuperview()
                }
            }
            
            _temp_top = view
        }
    }
}

extension JCAPPAuthInfoViewController: APPAuthCardInfoUnitProtocol {
    func JCAPPtouchAuthUnitInfo(itemView: JCAPPAuthCardInfoUnitView) {
        self.view.endEditing(true)
        guard let _choise = itemView.JCAPPunitTupe?.choise else {
            return
        }
        
        if itemView.input_type == .Input_Enum {
            JCAPPTextPickerPopView.JCAPPconvenienceShowPop(self.view, showCloseButton: true).JCAPPreloadTextPickerPopSource(_choise).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
                guard let _p_view = popView as? JCAPPTextPickerPopView else {
                    return
                }
                
                if let _key = itemView.JCAPPunitTupe?.cacheKey, let _code = _p_view.JCAPPtext_select_model?.late {
                    self?.JCAPPrequestParams.setValue(_code, forKey: _key)
                }
                
                itemView.JCAPPreloadUnitInfoText(_p_view.JCAPPtext_select_model?.foreign)
                
                _p_view.JCAPPdismissPop(false)
            }
        }
        
        if itemView.input_type == .Input_City {
            JCAPPSelectCityPickerPopView.JCAPPconvenienceShowPop(self.view, showCloseButton: true).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
                guard let _p_view = popView as? JCAPPSelectCityPickerPopView else {
                    return
                }
                
                if let _key = itemView.JCAPPunitTupe?.cacheKey, !_p_view.select_city.isEmpty {
                    self?.JCAPPrequestParams.setValue(_p_view.select_city.replacingOccurrences(of: " | ", with: "|"), forKey: _key)
                }
                
                itemView.JCAPPreloadUnitInfoText(_p_view.select_city)
                
                _p_view.JCAPPdismissPop(false)
            }
        }
    }
    
    func JCAPPdidEndEditing(itemView: JCAPPAuthCardInfoUnitView, inputValue: String?) {
        if let _text = inputValue, let _k = itemView.JCAPPunitTupe?.cacheKey {
            self.JCAPPrequestParams.setValue(_text, forKey: _k)
        }
    }
}
