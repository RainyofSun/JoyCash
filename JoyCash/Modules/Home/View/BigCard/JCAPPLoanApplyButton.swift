//
//  JCAPPLoanApplyButton.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

class JCAPPLoanApplyButton: UIControl {

    private lazy var imgView: UIImageView = UIImageView(image: UIImage(named: "main_apply_bg"))
    private lazy var titleLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.JCAPPDDINBoldFont(24), labelColor: UIColor.init(hexString: "#ED5E3A")!)
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.white)
        activityView.hidesWhenStopped = true
        activityView.alpha = .zero
        return activityView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imgView)
        self.addSubview(self.titleLab)
        self.addSubview(self.activityIndicatorView)
        
        self.imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-APP_PADDING_UNIT * 5)
        }
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func JCAPPsetApplyButtonTitle(_ text: String?) {
        self.titleLab.text = text
    }
}

extension JCAPPLoanApplyButton: ActivityAnimationProtocol {
    func startAnimation() {
        self.isEnabled = false
        self.activityIndicatorView.startAnimating()
        UIView.animate(withDuration: 0.3) {
            self.titleLab.alpha = .zero
            self.activityIndicatorView.alpha = 1
        }
    }
    
    func stopAnimation() {
        self.isEnabled = true
        UIView.animate(withDuration: 0.3) {
            self.titleLab.alpha = 1
            self.activityIndicatorView.alpha = 1
        } completion: { _ in
            self.activityIndicatorView.stopAnimating()
        }
    }
}
