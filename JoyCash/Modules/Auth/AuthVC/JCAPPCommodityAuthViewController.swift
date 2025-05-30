//
//  JCAPPCommodityAuthViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit

class JCAPPCommodityAuthViewController: JCAPPBaseViewController {
    
    private(set) lazy var JCAPPcontainerView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.borderColor = JCAPP_ORANGE_COLOR_F68941.cgColor
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private(set) lazy var JCAPPtitleLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.JCAPPgilroyFont(16), labelColor: .black)
    private(set) lazy var JCAPPcontentLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.systemFont(ofSize: 12), labelColor: UIColor.hexStringColor(hexString: "#554239", alpha: 0.5))
    
    private(set) lazy var JCAPPnextBtn: APPActivityButton = APPActivityButton.JCAPPbuildJoyCashGradientLoadingButton("Next", titleFont: UIFont.JCAPPDDINBoldFont(21), cornerRadius: 23)
    open var navTitle: String?
    
    init(certificationTitle title: String?) {
        super.init(nibName: nil, bundle: nil)
        self.navTitle = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func JCAPPbuildViewUI() {
        super.JCAPPbuildViewUI()
        self.title = self.navTitle
        
        self.JCAPPtitleLab.textAlignment = .left
        self.JCAPPcontentLab.textAlignment = .left
        self.JCAPPreloadDeviceLocation()
        
        self.JCAPPnextBtn.addTarget(self, action: #selector(JCAPPclickNextButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.JCAPPcontentView.isHidden = true
        self.view.addSubview(self.JCAPPcontainerView)
        self.JCAPPcontainerView.addSubview(self.JCAPPtitleLab)
        self.JCAPPcontainerView.addSubview(self.JCAPPcontentLab)
        self.view.addSubview(self.JCAPPnextBtn)
    }
    
    override func JCAPPlayoutControlViews() {
        super.JCAPPlayoutControlViews()
        
        self.JCAPPcontainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 3)
            make.top.equalToSuperview().offset(UIDevice.app_navigationBarAndStatusBarHeight() + APP_PADDING_UNIT * 3)
            make.bottom.lessThanOrEqualTo(self.JCAPPnextBtn.snp.top).offset(-APP_PADDING_UNIT * 3)
        }
        
        self.JCAPPtitleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
            make.height.equalTo(20)
        }
        
        self.JCAPPcontentLab.snp.makeConstraints { make in
            make.top.equalTo(self.JCAPPtitleLab.snp.bottom).offset(APP_PADDING_UNIT * 2)
            make.horizontalEdges.equalTo(self.JCAPPtitleLab)
        }
        
        self.JCAPPnextBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-UIDevice.app_safeDistanceBottom() - APP_PADDING_UNIT)
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 9)
            make.height.equalTo(46)
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.JCAPPpageNetowrkRequest()
    }
    
    public func JCAPPsetTipWithTitle(_ title: String, subTitle: String) {
        self.JCAPPtitleLab.text = title
        self.JCAPPcontentLab.text = subTitle
    }
}

@objc extension JCAPPCommodityAuthViewController {
    func JCAPPclickNextButton(sender: APPActivityButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
