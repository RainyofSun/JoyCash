//
//  JCAPPAuthCardInfoUnitView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/25.
//

import UIKit

protocol APPAuthCardInfoUnitProtocol: AnyObject {
    func touchAuthUnitInfo(itemView: JCAPPAuthCardInfoUnitView)
    func didEndEditing(itemView: JCAPPAuthCardInfoUnitView, inputValue: String?)
}

class JCAPPAuthCardInfoUnitView: UIView {

    weak open var unitDelegate: APPAuthCardInfoUnitProtocol?
    open var unitTupe: (cacheKey: String?, choise: [JCAPPCommonChoiseModel]?)?
    
    private lazy var titleLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.systemFont(ofSize: 15), labelColor: UIColor.hexStringColor(hexString: "#202020"))
    private lazy var noActionTextFiled: JCAPPForbidActionTextFiled = JCAPPForbidActionTextFiled.buildJoyCashNormalTextFiled(placeHolder: NSAttributedString())
    
    private(set) var input_type = JCInputViewType.Input_Text
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.noActionTextFiled.delegate = self
        self.titleLab.textAlignment = .left
        
        self.addSubview(self.titleLab)
        self.addSubview(self.noActionTextFiled)
        
        self.titleLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
            make.top.equalToSuperview().offset(APP_PADDING_UNIT)
        }
        
        self.noActionTextFiled.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
            make.top.equalTo(self.titleLab.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func setInfoUnitModel(_ model: JCAPPAuthInfoUnitModel, unitRightImage: UIImage?) {
        self.input_type = model.inputType
        self.unitTupe = (model.prize, model.identify)
        self.titleLab.text = model.graphic
        if let _att = model.amplitude {
            self.noActionTextFiled.attributedPlaceholder = NSAttributedString(string: _att, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#999999"), .font: UIFont.systemFont(ofSize: 15)])
        }
        
        if let _t = model.video {
            if model.inputType == .Input_Enum, let _item = model.identify?.first(where: {$0.late == _t}) {
                self.noActionTextFiled.text = _item.foreign
            } else {
                self.noActionTextFiled.text = _t
            }
        }
        
        if let _img = unitRightImage {
            let imgView: UIImageView = UIImageView(image: _img)
            self.noActionTextFiled.rightView = imgView
        }
        
        self.noActionTextFiled.keyboardType = model.ventilation ? .numberPad : .default
        self.noActionTextFiled.rightViewMode = self.input_type == .Input_Enum ? .always : .never
    }
    
    public func reloadContactRelationShip(model: JCAPPSelectContactsModel, type: JCInputViewType) {
        self.input_type = type
        self.unitTupe = ("", model.identify)
        if let _place = model.aims {
            self.noActionTextFiled.attributedPlaceholder = NSAttributedString(string: _place, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#999999"), .font: UIFont.systemFont(ofSize: 15)])
        }
        
        if let _title = model.reproducibility {
            self.titleLab.text = _title
        }
        
        if let _relation = model.historically, let _choise = model.identify, let item = _choise.first(where: {$0.late == _relation}) {
            self.noActionTextFiled.text = item.foreign
        }
    }
    
    public func reloadContactPhone(model: JCAPPSelectContactsModel, type: JCInputViewType) {
        self.input_type = type
        if let _place = model.elastography {
            self.noActionTextFiled.attributedPlaceholder = NSAttributedString(string: _place, attributes: [.foregroundColor: UIColor.hexStringColor(hexString: "#999999"), .font: UIFont.systemFont(ofSize: 15)])
        }
        
        if let _title = model.mre {
            self.titleLab.text = _title
        }
        
        if let _name = model.foreign, let _phone = model.interpretations, !_name.isEmpty && !_phone.isEmpty {
            self.noActionTextFiled.text = _name + " - " + _phone
        }
    }
    
    public func reloadUnitInfoText(_ text: String?) {
        if let _t = text {
            self.noActionTextFiled.text = _t
        }
    }
}

extension JCAPPAuthCardInfoUnitView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.unitDelegate?.touchAuthUnitInfo(itemView: self)
        return self.input_type == .Input_Text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.unitDelegate?.didEndEditing(itemView: self, inputValue: textField.text)
    }
}
