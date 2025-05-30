//
//  JCAPPOrderMenuView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

protocol APPOrderMenuProtocol: AnyObject {
    func didSeletedMenuItem(idx: Int)
}

class JCAPPOrderMenuView: UIScrollView {

    weak open var menuDelegate: APPOrderMenuProtocol?
    private(set) var selectedIndex: Int = .zero
    
    private var menuTitles: [String] = ["All", "Apply", "Repayment", "Finished"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var _tempButton: UIButton?
        menuTitles.enumerated().forEach { (idx: Int, title: String) in
            let view = UIButton.JCAPPbuildJoyCashNormalButton(title, titleFont: UIFont.systemFont(ofSize: 14), titleColor: UIColor.hexStringColor(hexString: "#1A1C19"))
            view.setTitle(title, for: UIControl.State.selected)
            view.setTitleColor(UIColor.white, for: UIControl.State.selected)
            view.layer.cornerRadius = 16
            view.clipsToBounds = true
            view.backgroundColor = idx == .zero ? UIColor.hexStringColor(hexString: "#F77745") : .white
            view.tag = 1000 + idx
            view.addTarget(self, action: #selector(JCAPPclickMenuItem(sender: )), for: UIControl.Event.touchUpInside)
            view.isSelected = idx == .zero
            self.addSubview(view)
            
            let text_width: CGFloat = title.jk.singleLineWidth(font: UIFont.systemFont(ofSize: 14)) + APP_PADDING_UNIT * 8
            if let _temp = _tempButton {
                if idx == menuTitles.count - 1 {
                    view.snp.makeConstraints { make in
                        make.left.equalTo(_temp.snp.right).offset(APP_PADDING_UNIT * 3)
                        make.height.centerY.equalTo(_temp)
                        make.width.equalTo(text_width)
                        make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 3)
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.left.equalTo(_temp.snp.right).offset(APP_PADDING_UNIT * 3)
                        make.height.centerY.equalTo(_temp)
                        make.width.equalTo(text_width)
                    }
                }
            } else {
                view.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(APP_PADDING_UNIT * 3)
                    make.size.equalTo(CGSize(width: text_width, height: 32))
                    make.top.equalToSuperview().offset(APP_PADDING_UNIT)
                }
            }
            
            _tempButton = view
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func JCAPPselectedMenuItem(idx: Int) {
        guard let _btn = self.viewWithTag(1000 + idx) as? UIButton else {
            return
        }
    
        self.JCAPPclickMenuItem(sender: _btn)
    }
}

private extension JCAPPOrderMenuView {
    func JCAPPresetMenuItemState() {
        for item in self.subviews {
            if let _btn = item as? UIButton, _btn.isSelected {
                _btn.isSelected = false
                _btn.backgroundColor = .white
                break
            }
        }
    }
}

@objc private extension JCAPPOrderMenuView {
    func JCAPPclickMenuItem(sender: UIButton) {
        self.JCAPPresetMenuItemState()
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? UIColor.hexStringColor(hexString: "#F77745") : .white
        self.selectedIndex = sender.tag - 1000
        self.menuDelegate?.didSeletedMenuItem(idx: self.selectedIndex)
    }
}
