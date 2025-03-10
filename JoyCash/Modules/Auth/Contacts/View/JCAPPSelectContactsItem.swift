//
//  JCAPPSelectContactsItem.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/3/1.
//

import UIKit

protocol APPSelectContactsItemProtocol: AnyObject {
    func contactsItemWasClicked(itemView: JCAPPSelectContactsItem, isRelationShip: Bool)
}

class JCAPPSelectContactsItem: UIView {

    weak open var itemDelegate: APPSelectContactsItemProtocol?
    
    private lazy var bigTitleLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.systemFont(ofSize: 15), labelColor: UIColor.hexStringColor(hexString: "#202020"))
    private(set) lazy var relationShipItem: JCAPPAuthCardInfoUnitView = JCAPPAuthCardInfoUnitView(frame: CGRectZero)
    private lazy var phoneItem: JCAPPAuthCardInfoUnitView = JCAPPAuthCardInfoUnitView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.relationShipItem.unitDelegate = self
        self.phoneItem.unitDelegate = self
        
        self.addSubview(self.bigTitleLab)
        self.addSubview(self.relationShipItem)
        self.addSubview(self.phoneItem)
        
        self.bigTitleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(APP_PADDING_UNIT)
            make.centerX.equalToSuperview()
        }
        
        self.relationShipItem.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
            make.top.equalTo(self.bigTitleLab.snp.bottom).offset(APP_PADDING_UNIT * 6)
        }
        
        self.phoneItem.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.relationShipItem)
            make.top.equalTo(self.relationShipItem.snp.bottom).offset(APP_PADDING_UNIT * 4)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadEmergencyContactModel(_ model: JCAPPSelectContactsModel) {
        self.bigTitleLab.text = model.graphic
        self.relationShipItem.reloadContactRelationShip(model: model, type: JCInputViewType.Input_Enum)
        self.phoneItem.reloadContactPhone(model: model, type: JCInputViewType.Input_Contacts)
    }
    
    public func reloadPhoneOrRelationship(_ phone: String? = nil, relationship: String? = nil) {
        if let _p = phone {
            self.phoneItem.reloadUnitInfoText(_p)
        }
        
        if let _r = relationship {
            self.relationShipItem.reloadUnitInfoText(_r)
        }
    }
}

extension JCAPPSelectContactsItem: APPAuthCardInfoUnitProtocol {
    func touchAuthUnitInfo(itemView: JCAPPAuthCardInfoUnitView) {
        self.itemDelegate?.contactsItemWasClicked(itemView: self, isRelationShip: (itemView == self.relationShipItem))
    }
    
    func didEndEditing(itemView: JCAPPAuthCardInfoUnitView, inputValue: String?) {
        
    }
}
