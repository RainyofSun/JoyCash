//
//  JCAPPCommodityAuthViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit

class JCAPPCommodityAuthViewController: JCAPPBaseViewController {
    
    private(set) lazy var containerView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.borderColor = BLUE_COLOR_4169F6.cgColor
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private(set) lazy var titleLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.gilroyFont(16), labelColor: .black)
    private(set) lazy var contentLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.systemFont(ofSize: 12), labelColor: UIColor.hexStringColor(hexString: "#554239", alpha: 0.5))
    
    private(set) lazy var nextBtn: JCAPPActivityButton = JCAPPActivityButton.buildJoyCashGradientLoadingButton("Next", cornerRadius: 23)
    open var navTitle: String?
    
    init(certificationTitle title: String?) {
        super.init(nibName: nil, bundle: nil)
        self.navTitle = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        self.title = self.navTitle
        
        self.titleLab.textAlignment = .left
        self.contentLab.textAlignment = .left
        self.reloadDeviceLocation()
        
        self.nextBtn.addTarget(self, action: #selector(clickNextButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.isHidden = true
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.titleLab)
        self.containerView.addSubview(self.contentLab)
        self.view.addSubview(self.nextBtn)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 3)
            make.top.equalToSuperview().offset(UIDevice.xp_navigationFullHeight() + APP_PADDING_UNIT * 3)
            make.bottom.lessThanOrEqualTo(self.nextBtn.snp.top).offset(-APP_PADDING_UNIT * 3)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
            make.height.equalTo(20)
        }
        
        self.contentLab.snp.makeConstraints { make in
            make.top.equalTo(self.titleLab.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.horizontalEdges.equalTo(self.titleLab)
        }
        
        self.nextBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-UIDevice.xp_safeDistanceBottom() - APP_PADDING_UNIT)
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 9)
            make.height.equalTo(46)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.pageNetowrkRequest()
    }
    
    public func setTipWithTitle(_ title: String, subTitle: String) {
        self.titleLab.text = title
        self.contentLab.text = subTitle
    }
}

@objc extension JCAPPCommodityAuthViewController {
    func clickNextButton(sender: JCAPPActivityButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
