//
//  JCAPPIDCardViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit
import Toast
import CYSwiftExtension

class JCAPPIDCardViewController: JCAPPCommodityAuthViewController {

    private lazy var JCAPPleftBtn: UIButton = {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.setBackgroundImage(UIImage(named: "certification_card"), for: UIControl.State.normal)
        view.corner(8)
        return view
    }()
    
    private lazy var JCAPPleftCompleteImgView: UIImageView = UIImageView(image: UIImage(named: "certification_complete"))
    
    private lazy var JCAPPrightBtn: UIButton = {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.setBackgroundImage(UIImage(named: "certification_face"), for: UIControl.State.normal)
        view.corner(8)
        return view
    }()
    private lazy var JCAPPrightCompleteImgView: UIImageView = UIImageView(image: UIImage(named: "certification_complete"))
    
    private var JCAPPisFace: Bool = false
    private var JCAPP_card_auth_model: JCAPPAuthCardModel?
    private var JCAPP_card_type: String = ""
    private lazy var cameraTool: APPMultimediaTool = APPMultimediaTool(presentViewController: self)
    
    override func JCAPPbuildViewUI() {
        super.JCAPPbuildViewUI()
        
        self.cameraTool.toolDelegate = self
        
        self.JCAPPsetTipWithTitle(String.JCAPP_yeurjmfkString(), subTitle: String.JCAPP_eokdmchString())
        
        self.JCAPPleftBtn.addTarget(self, action: #selector(JCAPPclickCardButton(sender: )), for: UIControl.Event.touchUpInside)
        self.JCAPPrightBtn.addTarget(self, action: #selector(JCAPPclickFaceButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.JCAPPleftCompleteImgView.isHidden = true
        self.JCAPPrightCompleteImgView.isHidden = true
        
        self.view.addSubview(self.JCAPPcontainerView)
        self.JCAPPcontainerView.addSubview(self.JCAPPcontentLab)
        self.JCAPPcontainerView.addSubview(self.JCAPPleftBtn)
        self.JCAPPleftBtn.addSubview(self.JCAPPleftCompleteImgView)
        self.JCAPPcontainerView.addSubview(self.JCAPPrightBtn)
        self.JCAPPrightBtn.addSubview(self.JCAPPrightCompleteImgView)
    }
    
    override func JCAPPlayoutControlViews() {
        super.JCAPPlayoutControlViews()
        
        self.JCAPPleftBtn.snp.makeConstraints { make in
            make.left.equalTo(self.JCAPPcontentLab)
            make.top.equalTo(self.JCAPPcontentLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
            make.size.equalTo(CGSize(width: (ScreenWidth - APP_PADDING_UNIT * 17) * 0.5, height: (ScreenWidth - APP_PADDING_UNIT * 17) * 0.325))
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 4)
        }
        
        self.JCAPPleftCompleteImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.JCAPPrightBtn.snp.makeConstraints { make in
            make.right.equalTo(self.JCAPPcontentLab)
            make.top.size.equalTo(self.JCAPPleftBtn)
        }
        
        self.JCAPPrightCompleteImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func JCAPPpageNetowrkRequest() {
        super.JCAPPpageNetowrkRequest()
        guard let _p_id = JCAPPPublic.shared.productID else {
            return
        }
        
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/power", requestParams: ["overuse": _p_id])) { [weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            guard let _dict = res.jsonDict, let _model = JCAPPAuthCardModel.model(withJSON: _dict) else {
                return
            }
            self?.JCAPP_card_auth_model = _model
            
            if let _card = _model.third?.zeugmatography, let _card_url = URL(string: _card) {
                self?.JCAPPleftBtn.setBackgroundImageWith(_card_url, for: UIControl.State.normal, options: YYWebImageOptions.setImageWithFadeAnimation)
                self?.JCAPPleftCompleteImgView.isHidden = false
            }
            
            if let _face = _model.least?.zeugmatography, let _face_url = URL(string: _face) {
                self?.JCAPPrightBtn.setBackgroundImageWith(_face_url, for: UIControl.State.normal, options: YYWebImageOptions.setImageWithFadeAnimation)
                self?.JCAPPrightCompleteImgView.isHidden = false
            }
            
            self?.JCAPPisFace = _model.third?.protocols ?? false
        }
    }
    
    override func JCAPPclickNextButton(sender: APPActivityButton) {
        guard let _cardModel = self.JCAPP_card_auth_model else {
            return
        }
        
        if let _card_complete = _cardModel.third?.protocols, !_card_complete {
            self.JCAPPclickCardButton(sender: self.JCAPPleftBtn)
            return
        }
        
        if let _face_complete = _cardModel.least?.protocols, !_face_complete {
            self.JCAPPclickFaceButton(sender: self.JCAPPrightBtn)
            return
        }
        
        super.JCAPPclickNextButton(sender: sender)
    }
}

private extension JCAPPIDCardViewController {
    func JCAPPuploadLocalImageFileToServer(_ filePath: String) {
        if !FileManager.default.fileExists(atPath: filePath) {
            APPCocoaLog.debug("------- 本地没有图片 ---------")
            return
        }
        
        self.view.makeToastActivity(CSToastPositionCenter)
        var params: [String: String] = ["relieveThat": filePath, "late": self.JCAPPisFace ? "10" : "11", "bodies": "1"]
        if !self.JCAPPisFace {
            params["second"] = self.JCAPP_card_type
        }
        
        let config: NetworkRequestConfig = NetworkRequestConfig.defaultRequestConfig("said/computational", requestParams: params)
        config.requestType = .upload
        APPNetRequestManager.afnReqeustType(config) { [weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            guard let _self = self else {
                return
            }
            
            _self.view.hideToastActivity()
            
            if _self.JCAPPisFace {
                // 埋点
                JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCAPPRiskControlPointsType.JC_APP_Face, beginTime: _self.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
                _self.navigationController?.popViewController(animated: true)
            } else {
                guard let _dict = res.jsonDict, let _infoModel = JCAPPAuthCardRecognitionModel.model(withJSON: _dict) else {
                    return
                }

                if let _occur_array = _infoModel.occur {
                    JCAPPAuthCardInfoPopView.JCAPPconvenienceShowPop(_self.view).JCAPPhideBack().JCAPPreloadCardInfoSource(_occur_array, tipText: _infoModel.failed, tipTitle: _infoModel.injuries).clickCloseClosure = { (popView: JCAPPBasePopView, isConfirm: Bool) in
                        guard let _info_pop = popView as? JCAPPAuthCardInfoPopView else {
                            return
                        }
                        
                        _info_pop.JCAPPconfirmBtn.startAnimation()
                        _info_pop.JCAPPsaveParams["late"] = "11"
                        _info_pop.JCAPPsaveParams["second"] = self?.JCAPP_card_type
                        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/amount", requestParams: _info_pop.JCAPPsaveParams)) { _, _ in
                            _info_pop.JCAPPconfirmBtn.stopAnimation()
                            // 埋点
                            JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCAPPRiskControlPointsType.JC_APP_TakingCardPhoto, beginTime: _self.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
                            _self.JCAPP_card_auth_model?.third?.protocols = true
                            _self.JCAPPisFace = true
                            popView.JCAPPdismissPop()
                        } failure: { _, _ in
                            _info_pop.JCAPPconfirmBtn.stopAnimation()
                        }
                    }
                } else {
                    // 埋点
                    JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCAPPRiskControlPointsType.JC_APP_TakingCardPhoto, beginTime: _self.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
                    _self.JCAPP_card_auth_model?.third?.protocols = true
                    _self.JCAPPisFace = true
                }
                
                if let _img_url = _infoModel.zeugmatography, let _url = URL(string: _img_url) {
                    _self.JCAPPleftBtn.setBackgroundImageWith(_url, for: UIControl.State.normal, options: .progressiveBlur)
                    _self.JCAPPleftCompleteImgView.isHidden = false
                }
            }
        } failure: { [weak self] _, _ in
            self?.view.hideToastActivity()
        }
    }
}

// MARK: APPMultimediaProtocol
extension JCAPPIDCardViewController: APPMultimediaProtocol {
    func selectedPictureFormMultimediaComplete(_ filePath: String) {
        self.JCAPPuploadLocalImageFileToServer(filePath)
    }
}

extension JCAPPIDCardViewController: CardTypeSelectedProtocol {
    func JCAPPdidSelectedCardType(cardType: String?) {
        // 埋点
        JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCAPPRiskControlPointsType.JC_APP_IDCardType, beginTime: self.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
        self.JCAPP_card_type = cardType ?? ""
        self.buryBeginTime = Date().jk.dateToTimeStamp()
        if let _style = self.JCAPP_card_auth_model?.appears {
            if _style == 0 {
                self.cameraTool.showAlertSheet { [weak self] (isCamera: Bool) in
                    isCamera ? self?.cameraTool.takingPhoto(false) : self?.cameraTool.takingPictureFormAlbum()
                }
            } else {
                self.cameraTool.takingPhoto(false)
            }
        }
    }
}

@objc private extension JCAPPIDCardViewController {
    func JCAPPclickCardButton(sender: UIButton) {
        guard let _card_model = self.JCAPP_card_auth_model else {
            return
        }
        
        if let _complete = _card_model.third?.protocols, _complete {
            return
        }
        
        // 刷新定位
        self.JCAPPreloadDeviceLocation()
        JCAPPAuthCardPopView.JCAPPconvenienceShowPop(self.view).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
            if isConfirm, let _first = _card_model.pregnancy, let _sec = _card_model.eyes, let _self = self {
                self?.buryBeginTime = Date().jk.dateToTimeStamp()
                self?.navigationController?.pushViewController(JCAPPCardTypeSelectedViewController(certificationTitle: self?.navTitle, cardTypes: [_first, _sec], delegate: _self), animated: true)
            }
            
            popView.JCAPPdismissPop()
        }
    }
    
    func JCAPPclickFaceButton(sender: UIButton) {
        guard let _card_model = self.JCAPP_card_auth_model else {
            return
        }
    
        guard let _id_model = _card_model.third, _id_model.protocols else {
            self.view.makeToast(String.JCAPP_ysudndmdsString())
            return
        }
        
        if let _complete = _card_model.least?.protocols, _complete {
            return
        }
        
        // 刷新定位
        self.JCAPPreloadDeviceLocation()
        JCAPPAuthFacePopView.JCAPPconvenienceShowPop(self.view).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
            if isConfirm {
                self?.buryBeginTime = Date().jk.dateToTimeStamp()
                self?.cameraTool.takingPhoto(true)
            }
            
            popView.JCAPPdismissPop()
        }
    }
}
