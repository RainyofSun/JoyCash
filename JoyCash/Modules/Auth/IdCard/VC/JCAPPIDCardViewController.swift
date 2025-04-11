//
//  JCAPPIDCardViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit
import Toast
import TZImagePickerController

class JCAPPIDCardViewController: JCAPPCommodityAuthViewController {

    private lazy var leftBtn: UIButton = {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.setBackgroundImage(UIImage(named: "certification_card"), for: UIControl.State.normal)
        view.corner(8)
        return view
    }()
    
    private lazy var leftCompleteImgView: UIImageView = UIImageView(image: UIImage(named: "certification_complete"))
    
    private lazy var rightBtn: UIButton = {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.setBackgroundImage(UIImage(named: "certification_face"), for: UIControl.State.normal)
        view.corner(8)
        return view
    }()
    private lazy var rightCompleteImgView: UIImageView = UIImageView(image: UIImage(named: "certification_complete"))
    
    private var isFace: Bool = false
    private var _card_auth_model: JCAPPAuthCardModel?
    private var _card_type: String = ""
    
    override func buildViewUI() {
        super.buildViewUI()
        
        self.setTipWithTitle("Identity authentication", subTitle: "Please fill in your personal information (don't worry, your information and data are protected)")
        
        self.leftBtn.addTarget(self, action: #selector(clickCardButton(sender: )), for: UIControl.Event.touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(clickFaceButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.leftCompleteImgView.isHidden = true
        self.rightCompleteImgView.isHidden = true
        
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.contentLab)
        self.containerView.addSubview(self.leftBtn)
        self.leftBtn.addSubview(self.leftCompleteImgView)
        self.containerView.addSubview(self.rightBtn)
        self.rightBtn.addSubview(self.rightCompleteImgView)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.leftBtn.snp.makeConstraints { make in
            make.left.equalTo(self.contentLab)
            make.top.equalTo(self.contentLab.snp.bottom).offset(APP_PADDING_UNIT * 3)
            make.size.equalTo(CGSize(width: (ScreenWidth - APP_PADDING_UNIT * 17) * 0.5, height: (ScreenWidth - APP_PADDING_UNIT * 17) * 0.325))
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 4)
        }
        
        self.leftCompleteImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.rightBtn.snp.makeConstraints { make in
            make.right.equalTo(self.contentLab)
            make.top.size.equalTo(self.leftBtn)
        }
        
        self.rightCompleteImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func pageNetowrkRequest() {
        super.pageNetowrkRequest()
        guard let _p_id = JCAPPPublic.shared.productID else {
            return
        }
        
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/power", requestParams: ["overuse": _p_id])) { [weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            guard let _dict = res.jsonDict, let _model = JCAPPAuthCardModel.model(withJSON: _dict) else {
                return
            }
            self?._card_auth_model = _model
            
            if let _card = _model.third?.zeugmatography, let _card_url = URL(string: _card) {
                self?.leftBtn.setBackgroundImageWith(_card_url, for: UIControl.State.normal, options: YYWebImageOptions.setImageWithFadeAnimation)
                self?.leftCompleteImgView.isHidden = false
            }
            
            if let _face = _model.least?.zeugmatography, let _face_url = URL(string: _face) {
                self?.rightBtn.setBackgroundImageWith(_face_url, for: UIControl.State.normal, options: YYWebImageOptions.setImageWithFadeAnimation)
                self?.rightCompleteImgView.isHidden = false
            }
            
            self?.isFace = _model.third?.protocols ?? false
        }
    }
    
    override func clickNextButton(sender: APPActivityButton) {
        guard let _cardModel = self._card_auth_model else {
            return
        }
        
        if let _card_complete = _cardModel.third?.protocols, !_card_complete {
            self.clickCardButton(sender: self.leftBtn)
            return
        }
        
        if let _face_complete = _cardModel.least?.protocols, !_face_complete {
            self.clickFaceButton(sender: self.rightBtn)
            return
        }
        
        super.clickNextButton(sender: sender)
    }
}

private extension JCAPPIDCardViewController {
    func takingPhotoWithDeviceCamera(_ isFront: Bool) {
        DeviceAuthorizationTool.authorization().requestDeviceCameraAuthrization {[weak self] (auth: Bool) in
            if !auth {
                self?.showSystemStyleSettingAlert("Authorize camera access to easily take ID card photos and have a convenient operation process.", okTitle: nil, cancelTitle: nil)
                return
            }
            
            dispatch_async_on_main_queue {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    let pickerController = UIImagePickerController()
                    pickerController.allowsEditing = false
                    pickerController.sourceType = .camera
                    pickerController.cameraDevice = isFront ? .front : .rear
                    pickerController.delegate = self
                    self?.navigationController?.present(pickerController, animated: true)
                }
            }
        }
    }
    
    func uploadLocalImageFileToServer(_ filePath: String) {
        if !FileManager.default.fileExists(atPath: filePath) {
            JCAPPProductLog.debug("------- 本地没有图片 ---------")
            return
        }
        
        self.view.makeToastActivity(CSToastPositionCenter)
        var params: [String: String] = ["relieveThat": filePath, "late": self.isFace ? "10" : "11", "bodies": "1"]
        if !self.isFace {
            params["second"] = self._card_type
        }
        
        let config: NetworkRequestConfig = NetworkRequestConfig.defaultRequestConfig("said/computational", requestParams: params)
        config.requestType = .upload
        APPNetRequestManager.afnReqeustType(config) { [weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            guard let _self = self else {
                return
            }
            
            _self.view.hideToastActivity()
            
            if _self.isFace {
                // 埋点
                JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCRiskControlPointsType.JC_APP_Face, beginTime: _self.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
                _self.navigationController?.popViewController(animated: true)
            } else {
                guard let _dict = res.jsonDict, let _infoModel = JCAPPAuthCardRecognitionModel.model(withJSON: _dict) else {
                    return
                }

                if let _occur_array = _infoModel.occur {
                    JCAPPAuthCardInfoPopView.convenienceShowPop(_self.view).hideBack().reloadCardInfoSource(_occur_array, tipText: _infoModel.failed, tipTitle: _infoModel.injuries).clickCloseClosure = { (popView: JCAPPBasePopView, isConfirm: Bool) in
                        guard let _info_pop = popView as? JCAPPAuthCardInfoPopView else {
                            return
                        }
                        
                        _info_pop.confirmBtn.startAnimation()
                        _info_pop.saveParams["late"] = "11"
                        _info_pop.saveParams["second"] = self?._card_type
                        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/amount", requestParams: _info_pop.saveParams)) { _, _ in
                            _info_pop.confirmBtn.stopAnimation()
                            // 埋点
                            JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCRiskControlPointsType.JC_APP_TakingCardPhoto, beginTime: _self.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
                            _self._card_auth_model?.third?.protocols = true
                            _self.isFace = true
                            popView.dismissPop()
                        } failure: { _, _ in
                            _info_pop.confirmBtn.stopAnimation()
                        }
                    }
                } else {
                    // 埋点
                    JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCRiskControlPointsType.JC_APP_TakingCardPhoto, beginTime: _self.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
                    _self._card_auth_model?.third?.protocols = true
                    _self.isFace = true
                }
                
                if let _img_url = _infoModel.zeugmatography, let _url = URL(string: _img_url) {
                    _self.leftBtn.setBackgroundImageWith(_url, for: UIControl.State.normal, options: .progressiveBlur)
                    _self.leftCompleteImgView.isHidden = false
                }
            }
        } failure: { [weak self] _, _ in
            self?.view.hideToastActivity()
        }
    }
    
    func showAlertSheet(showPhoto: Bool, callBlock:(@escaping (Bool) -> Void)) {
        let alertSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let alertAction1: UIAlertAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { _ in
            callBlock(true)
        }
        alertSheet.addAction(alertAction1)
        
        if showPhoto {
            let alertAction2: UIAlertAction = UIAlertAction(title: "Photo", style: UIAlertAction.Style.default) { _ in
                callBlock(false)
            }
            alertSheet.addAction(alertAction2)
        }
        
        let alertAction3: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { _ in
            
        }
        alertSheet.addAction(alertAction3)
        
        self.present(alertSheet, animated: true)
    }
    
    func showTZImagePicker() {
        DeviceAuthorizationTool.authorization().requestDevicePhotoAuthrization(ReadAndWrite) { [weak self] (auth: Bool) in
            guard auth else {
                self?.showSystemStyleSettingAlert("Grant album permission to conveniently select and upload identity photos and accelerate the application process", okTitle: nil, cancelTitle: nil)
                return
            }
            dispatch_async_on_main_queue {
                let imagePickerVc = TZImagePickerController(maxImagesCount: 1, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)
                imagePickerVc?.allowPickingImage = true
                imagePickerVc?.allowTakeVideo = false
                imagePickerVc?.allowPickingGif = false
                imagePickerVc?.allowPickingVideo = false
                imagePickerVc?.allowCrop = true
                imagePickerVc?.cropRect = CGRect(x: 0, y: (ScreenHeight - ScreenWidth) * 0.5, width: ScreenWidth, height: ScreenWidth)
                imagePickerVc?.statusBarStyle = .lightContent
                imagePickerVc?.modalPresentationStyle = .fullScreen
                self?.present(imagePickerVc!, animated: true, completion: nil)
            }
        }
    }
}

extension JCAPPIDCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImg: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let compress_img_data = originalImg.jk.compressDataSize(maxSize: 1024 * 1024)
        let _filePath = self.isFace ? JCAPPPublic.shared.saveFaceImgPath : JCAPPPublic.shared.saveCardImgPath
        try? compress_img_data?.write(to: NSURL(fileURLWithPath: _filePath) as URL)
        self.uploadLocalImageFileToServer(_filePath)
        picker.dismiss(animated: true)
    }
}

// MARK: TZImagePickerControllerDelegate
extension JCAPPIDCardViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        guard let image = photos.first else {
            return
        }

        let compress_img_data = image.jk.compressDataSize(maxSize: 1024 * 1024)
        let _filePath = self.isFace ? JCAPPPublic.shared.saveFaceImgPath : JCAPPPublic.shared.saveCardImgPath
        try? compress_img_data?.write(to: NSURL(fileURLWithPath: _filePath) as URL)
        self.uploadLocalImageFileToServer(_filePath)
        picker.dismiss(animated: true)
    }
}

extension JCAPPIDCardViewController: CardTypeSelectedProtocol {
    func didSelectedCardType(cardType: String?) {
        // 埋点
        JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCRiskControlPointsType.JC_APP_IDCardType, beginTime: self.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
        self._card_type = cardType ?? ""
        self.buryBeginTime = Date().jk.dateToTimeStamp()
        if let _style = self._card_auth_model?.appears {
            self.showAlertSheet(showPhoto: (_style == 0), callBlock: { [weak self] (isCamera: Bool) in
                isCamera ? self?.takingPhotoWithDeviceCamera(false) : self?.showTZImagePicker()
            })
        }
    }
}

@objc private extension JCAPPIDCardViewController {
    func clickCardButton(sender: UIButton) {
        guard let _card_model = self._card_auth_model else {
            return
        }
        
        if let _complete = _card_model.third?.protocols, _complete {
            return
        }
        
        // 刷新定位
        self.reloadDeviceLocation()
        JCAPPAuthCardPopView.convenienceShowPop(self.view).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
            if isConfirm, let _first = _card_model.pregnancy, let _sec = _card_model.eyes, let _self = self {
                self?.buryBeginTime = Date().jk.dateToTimeStamp()
                self?.navigationController?.pushViewController(JCAPPCardTypeSelectedViewController(certificationTitle: self?.navTitle, cardTypes: [_first, _sec], delegate: _self), animated: true)
            }
            
            popView.dismissPop()
        }
    }
    
    func clickFaceButton(sender: UIButton) {
        guard let _card_model = self._card_auth_model else {
            return
        }
    
        guard let _id_model = _card_model.third, _id_model.protocols else {
            self.view.makeToast("Please upload a photo of your ID first")
            return
        }
        
        if let _complete = _card_model.least?.protocols, _complete {
            return
        }
        
        // 刷新定位
        self.reloadDeviceLocation()
        JCAPPAuthFacePopView.convenienceShowPop(self.view).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
            if isConfirm {
                self?.buryBeginTime = Date().jk.dateToTimeStamp()
                self?.takingPhotoWithDeviceCamera(true)
            }
            
            popView.dismissPop()
        }
    }
}
