//
//  JCAPPSelectContactsItem.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/3/1.
//

import UIKit

protocol APPSelectContactsItemProtocol: AnyObject {
    func JCAPPcontactsItemWasClicked(itemView: JCAPPSelectContactsItem, isRelationShip: Bool)
}

class JCAPPSelectContactsItem: UIView {

    weak open var itemDelegate: APPSelectContactsItemProtocol?
    
    private lazy var JCAPPbigTitleLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.systemFont(ofSize: 15), labelColor: UIColor.hexStringColor(hexString: "#202020"))
    private(set) lazy var JCAPPrelationShipItem: JCAPPAuthCardInfoUnitView = JCAPPAuthCardInfoUnitView(frame: CGRectZero)
    private lazy var JCAPPphoneItem: JCAPPAuthCardInfoUnitView = JCAPPAuthCardInfoUnitView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.JCAPPrelationShipItem.unitDelegate = self
        self.JCAPPphoneItem.unitDelegate = self
        
        self.addSubview(self.JCAPPbigTitleLab)
        self.addSubview(self.JCAPPrelationShipItem)
        self.addSubview(self.JCAPPphoneItem)
        
        self.JCAPPbigTitleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(APP_PADDING_UNIT)
            make.centerX.equalToSuperview()
        }
        
        self.JCAPPrelationShipItem.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
            make.top.equalTo(self.JCAPPbigTitleLab.snp.bottom).offset(APP_PADDING_UNIT * 6)
        }
        
        self.JCAPPphoneItem.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.JCAPPrelationShipItem)
            make.top.equalTo(self.JCAPPrelationShipItem.snp.bottom).offset(APP_PADDING_UNIT * 4)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func JCAPPreloadEmergencyContactModel(_ model: JCAPPSelectContactsModel) {
        self.JCAPPbigTitleLab.text = model.graphic
        self.JCAPPrelationShipItem.JCAPPreloadContactRelationShip(model: model, type: JCAPPInputViewType.Input_Enum)
        self.JCAPPphoneItem.JCAPPreloadContactPhone(model: model, type: JCAPPInputViewType.Input_Contacts)
    }
    
    public func JCAPPreloadPhoneOrRelationship(_ phone: String? = nil, relationship: String? = nil) {
        if let _p = phone {
            self.JCAPPphoneItem.JCAPPreloadUnitInfoText(_p)
        }
        
        if let _r = relationship {
            self.JCAPPrelationShipItem.JCAPPreloadUnitInfoText(_r)
        }
    }
}

extension JCAPPSelectContactsItem: APPAuthCardInfoUnitProtocol {
    func JCAPPtouchAuthUnitInfo(itemView: JCAPPAuthCardInfoUnitView) {
        self.itemDelegate?.JCAPPcontactsItemWasClicked(itemView: self, isRelationShip: (itemView == self.JCAPPrelationShipItem))
    }
    
    func JCAPPdidEndEditing(itemView: JCAPPAuthCardInfoUnitView, inputValue: String?) {
        
    }
}
