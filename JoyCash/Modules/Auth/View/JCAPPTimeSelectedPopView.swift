//
//  JCAPPTimeSelectedPopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/26.
//

import UIKit
import BRPickerView

class JCAPPTimeSelectedPopView: JCAPPBasePopView {

    private lazy var timePickerView: BRDatePickerView = {
        let picker = BRDatePickerView(frame: CGRectZero)
        picker.minDate = NSDate.br_setYear(1949, month: 3, day: 12)
        picker.maxDate = NSDate.now
        picker.pickerMode = .YMD
        let pickerStyle = BRPickerStyle()
        pickerStyle.hiddenDoneBtn = true
        pickerStyle.hiddenCancelBtn = true
        pickerStyle.hiddenTitleLine = true
        pickerStyle.pickerColor = .clear
        pickerStyle.pickerTextColor = BLACK_COLOR_26264A
        pickerStyle.pickerTextFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        pickerStyle.selectRowTextColor = BLUE_COLOR_4169F6
        pickerStyle.selectRowTextFont = UIFont.boldSystemFont(ofSize: 20)
        pickerStyle.pickerHeight = 305
#if DEBUG
        pickerStyle.language = "en"
#else
        if VCAPPDiskCache.readAPPLanguageFormDiskCache() == .Spanish {
            pickerStyle.language = "es"
        } else {
            pickerStyle.language = "en"
        }
#endif
        picker.pickerStyle = pickerStyle
        
        return picker
    }()
    
    private lazy var pickerContentView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth - APP_PADDING_UNIT * 8, height: 305))
    private(set) var selectedDate: String?
    
    override func buildPopViews() {
        super.buildPopViews()
        self.popTitleLab.text = "Select a time"
        
        self.contentView.addSubview(self.pickerContentView)
        self.timePickerView.addPicker(to: self.pickerContentView)
        
        self.timePickerView.resultBlock = {[weak self] (selectDate: Date?, selectValue: String?) in
            guard let _date = selectDate else {
                return
            }
            self?.selectedDate = NSDate.br_string(from: _date, dateFormat: "dd-MM-yyyy")
        }
    }
    
    override func layoutPopViews() {
        super.layoutPopViews()
        
        self.pickerContentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(305)
        }
    }
    
    public override class func convenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
        let view = JCAPPTimeSelectedPopView(frame: UIScreen.main.bounds, showCloseButton: show)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
    
    override func clickConfirmButton(sender: JCAPPActivityButton) {
        self.timePickerView.doneBlock?()
        super.clickConfirmButton(sender: sender)
    }
}
