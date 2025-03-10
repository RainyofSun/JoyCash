//
//  JCAPPLoanApplyButton.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

protocol ActivityAnimationProtocol: UIControl {
    func startAnimation()
    func stopAnimation()
}

class JCAPPLoanApplyButton: UIControl {

    private lazy var imgView: UIImageView = UIImageView(image: UIImage(named: "main_apply_bg"))
    private lazy var arrowImgView: UIImageView = UIImageView(image: UIImage(named: "main_apply_bg_arrow"))
    private lazy var titleLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.gilroyFont(18), labelColor: .white)
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.white)
        activityView.hidesWhenStopped = true
        activityView.alpha = .zero
        return activityView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imgView)
        self.addSubview(self.arrowImgView)
        self.addSubview(self.titleLab)
        self.addSubview(self.activityIndicatorView)
        
        self.imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.arrowImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 3.5)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
    
    public func setApplyButtonTitle(_ text: String?) {
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
