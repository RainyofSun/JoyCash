//
//  JCAPPTextPickerPopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/26.
//

import UIKit
import BRPickerView

class JCAPPTextPickerPopView: JCAPPBasePopView {
    
    open var JCAPPtext_select_model: JCAPPCommonChoiseModel?
    
    private lazy var JCAPPpickerView: BRTextPickerView = {
        let _pickView = BRTextPickerView(pickerMode: BRTextPickerMode.componentSingle)
        let style: BRPickerStyle = BRPickerStyle()
        style.hiddenDoneBtn = true
        style.hiddenCancelBtn = true
        style.hiddenTitleLine = true
        style.pickerColor = .white
        style.pickerTextColor = BLACK_COLOR_26264A
        style.pickerTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        style.selectRowTextColor = JCAPP_ORANGE_COLOR_F68941
        style.pickerHeight = 250
        _pickView.pickerStyle = style
        return _pickView
    }()
    
    private lazy var JCAPPpickerContentView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth - APP_PADDING_UNIT * 8, height: 250))
    
    override func JCAPPbuildPopViews() {
        super.JCAPPbuildPopViews()
        self.JCAPPpopTitleLab.text = String.JCAPP_skkkTieleString()
        
        self.JCAPPcontentView.addSubview(self.JCAPPpickerContentView)
        self.JCAPPpickerView.addPicker(to: self.JCAPPpickerContentView)
        
        self.JCAPPpickerView.singleChangeBlock = {[weak self] (model: BRTextModel?, idx: Int) in
            self?.JCAPPtext_select_model = JCAPPCommonChoiseModel()
            self?.JCAPPtext_select_model?.late = model?.code
            self?.JCAPPtext_select_model?.foreign = model?.text
        }
        
        self.JCAPPpickerView.singleResultBlock = {[weak self] (model: BRTextModel?, idx: Int) in
            self?.JCAPPtext_select_model = JCAPPCommonChoiseModel()
            self?.JCAPPtext_select_model?.late = model?.code
            self?.JCAPPtext_select_model?.foreign = model?.text
        }
    }
    
    override func JCAPPlayoutPopViews() {
        super.JCAPPlayoutPopViews()
        
        self.JCAPPpickerContentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(250)
        }
    }
    
    public override class func JCAPPconvenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
        let view = JCAPPTextPickerPopView(frame: UIScreen.main.bounds, showCloseButton: show)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
    
    override func JCAPPclickConfirmButton(sender: APPActivityButton) {
        self.JCAPPpickerView.doneBlock?()
        super.JCAPPclickConfirmButton(sender: sender)
    }
    
    public func JCAPPreloadTextPickerPopSource(_ data: [JCAPPCommonChoiseModel]) -> Self {
        var source_array: [[String: String]] = []
        data.forEach { (item: JCAPPCommonChoiseModel) in
            if let _code = item.late, let _text = item.foreign {
                source_array.append(["code": _code, "text": _text])
            }
        }
        
        self.JCAPPpickerView.dataSourceArr = NSArray.br_modelArray(withJson: source_array, mapper: nil)
        self.JCAPPpickerView.reloadData()
        
        return self
    }
}
