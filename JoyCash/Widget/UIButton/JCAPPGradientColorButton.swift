//
//  JCAPPGradientColorButton.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPGradientColorButton: UIButton {

    private lazy var bgGradientView: JCAPPGradientColorView = {
        let view = JCAPPGradientColorView(frame: CGRectZero)
        view.buildGradientWithColors()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.bgGradientView)
        self.bgGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }

}
