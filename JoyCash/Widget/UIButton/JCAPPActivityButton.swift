//
//  JCAPPActivityButton.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPActivityButton: JCAPPGradientColorButton {

    private var activityIndicatorView: UIActivityIndicatorView?
    private var _btnTitle: String?
    private var _btnImg: UIImage?
    
    deinit {
        deallocPrint()
    }
}

extension JCAPPActivityButton: ActivityAnimationProtocol {
    func startAnimation() {
        _btnTitle = self.currentTitle
        self.setTitle("", for: UIControl.State.normal)
        _btnImg = self.currentImage
        self.setImage(nil, for: UIControl.State.normal)
        
        if self.activityIndicatorView == nil {
            let activityView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.white)
            activityView.hidesWhenStopped = true
            self.addSubview(activityView)
            activityView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            self.activityIndicatorView = activityView
        } else {
            self.activityIndicatorView?.alpha = 1
        }
        
        self.activityIndicatorView?.startAnimating()
        self.isEnabled = false
    }
    
    func stopAnimation() {
        if let _activityView = self.activityIndicatorView {
            UIView.animate(withDuration: 0.3) {
                _activityView.alpha = 0
            } completion: { _ in
                _activityView.stopAnimating()
            }
            self.setTitle(_btnTitle, for: UIControl.State.normal)
            self.setImage(_btnImg, for: UIControl.State.normal)
            self.isEnabled = true
        }
    }
}
