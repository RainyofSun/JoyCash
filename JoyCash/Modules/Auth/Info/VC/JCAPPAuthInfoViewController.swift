//
//  JCAPPAuthInfoViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit

enum AuthInfoStyle {
    case PersonalInfo
    case WorkingInfo
    case BankCard
}

class JCAPPAuthInfoViewController: JCAPPCommodityAuthViewController {

    private var request_tupe: (requestUrl: String, saveUrl: String, riskType: JCRiskControlPointsType)?
    private var title_tupe: (title: String, subTitle: String)?
    private var requestParams: NSMutableDictionary = NSMutableDictionary()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRectZero)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private var _sub_height: CGFloat = 20
    
    init(certificationTitle title: String?, infoStyle style: AuthInfoStyle) {
        super.init(certificationTitle: title)
        switch style {
        case .PersonalInfo:
            self.request_tupe = ("said/practical", "said/crucial", .JC_APP_PersonalInfo)
            self.title_tupe = ("Basic information", "You need to fill in your basic information")
        case .WorkingInfo:
            self.request_tupe = ("said/quick", "said/manual", .JC_APP_WorkingInfo)
            self.title_tupe = ("Job information", "Employment information is a very important information to ensure that you can get a loan")
        case .BankCard:
            self.request_tupe = ("said/built", "said/incorporated", .JC_APP_BindingBankCard)
            self.title_tupe = ("Bank card binding", "Fill in your bank card information to facilitate payment")
        }
        
        guard let _sub = self.title_tupe?.subTitle else {
            return
        }
        
        self._sub_height = _sub.jk.heightAccording(width: ScreenWidth - APP_PADDING_UNIT * 14, font: UIFont.systemFont(ofSize: 12))
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        if let _tupe = self.title_tupe {
            self.setTipWithTitle(_tupe.title, subTitle: _tupe.subTitle)
        }
        
        self.containerView.addSubview(self.scrollView)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.contentLab.snp.removeConstraints()
        self.contentLab.snp.remakeConstraints { make in
            make.top.equalTo(self.titleLab.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.horizontalEdges.equalTo(self.titleLab)
            make.height.equalTo(self._sub_height)
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.contentLab.snp.bottom).offset(APP_PADDING_UNIT * 5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(ScreenHeight - UIDevice.xp_navigationFullHeight() - UIDevice.xp_safeDistanceBottom() - APP_PADDING_UNIT * 38 - self._sub_height)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pageNetowrkRequest() {
        super.pageNetowrkRequest()
        
        guard let _p_id = JCAPPPublic.shared.productID, let _tupe = self.request_tupe else {
            return
        }
        
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig(_tupe.requestUrl, requestParams: ["overuse": _p_id])) {[weak self] (task: URLSessionDataTask, res: JCAPPSuccessResponse) in
            guard let _json_dict = res.jsonDict, let _json_array = _json_dict["befored"] as? NSArray, let _json_models = NSArray.modelArray(with: JCAPPAuthInfoUnitModel.self, json: _json_array) as? [JCAPPAuthInfoUnitModel] else {
                return
            }
            
            self?.buildUnitInfoViews(_json_models)
        }
    }
    
    override func clickNextButton(sender: JCAPPActivityButton) {
        guard let _p_id = JCAPPPublic.shared.productID, let _tupe = self.request_tupe else {
            return
        }
        
        self.requestParams.setValue(_p_id, forKey: "overuse")
        JCAPPProductLog.debug("------ \n\(self.requestParams)\n -------")
        sender.startAnimation()
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig(_tupe.saveUrl, requestParams: self.requestParams as? [String : String])) {[weak self] (task: URLSessionDataTask, res: JCAPPSuccessResponse) in
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
    func buildUnitInfoViews(_ models: [JCAPPAuthInfoUnitModel]) {
        var _temp_top: JCAPPAuthCardInfoUnitView?
        
        models.enumerated().forEach { (idx: Int, item: JCAPPAuthInfoUnitModel) in
            let view = JCAPPAuthCardInfoUnitView(frame: CGRectZero)
            view.setInfoUnitModel(item, unitRightImage: UIImage(named: "pop_down_arrow"))
            view.unitDelegate = self
            self.scrollView.addSubview(view)
            if let _back = item.video, let _k = item.prize {
                self.requestParams.setValue(_back, forKey: _k)
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
    func touchAuthUnitInfo(itemView: JCAPPAuthCardInfoUnitView) {
        self.view.endEditing(true)
        guard let _choise = itemView.unitTupe?.choise else {
            return
        }
        
        if itemView.input_type == .Input_Enum {
            JCAPPTextPickerPopView.convenienceShowPop(self.view, showCloseButton: true).reloadTextPickerPopSource(_choise).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
                guard let _p_view = popView as? JCAPPTextPickerPopView else {
                    return
                }
                
                if let _key = itemView.unitTupe?.cacheKey, let _code = _p_view.text_select_model?.late {
                    self?.requestParams.setValue(_code, forKey: _key)
                }
                
                itemView.reloadUnitInfoText(_p_view.text_select_model?.foreign)
                
                _p_view.dismissPop(false)
            }
        }
        
        if itemView.input_type == .Input_City {
            JCAPPSelectCityPickerPopView.convenienceShowPop(self.view, showCloseButton: true).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
                guard let _p_view = popView as? JCAPPSelectCityPickerPopView else {
                    return
                }
                
                if let _key = itemView.unitTupe?.cacheKey, !_p_view.select_city.isEmpty {
                    self?.requestParams.setValue(_p_view.select_city.replacingOccurrences(of: " | ", with: "|"), forKey: _key)
                }
                
                itemView.reloadUnitInfoText(_p_view.select_city)
                
                _p_view.dismissPop(false)
            }
        }
    }
    
    func didEndEditing(itemView: JCAPPAuthCardInfoUnitView, inputValue: String?) {
        if let _text = inputValue, let _k = itemView.unitTupe?.cacheKey {
            self.requestParams.setValue(_text, forKey: _k)
        }
    }
}
