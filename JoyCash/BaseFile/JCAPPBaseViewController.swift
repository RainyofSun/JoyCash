//
//  JCAPPBaseViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
import FDFullscreenPopGesture
@_exported import JKSwiftExtension

class JCAPPBaseViewController: UIViewController {

    private lazy var JCAPPtopImageView: UIImageView = UIImageView(frame: CGRectZero)
    
    private(set) lazy var JCAPPcontentView: UIScrollView = {
        let view = UIScrollView(frame: CGRectZero)
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private(set) lazy var JCAPPgradientView: GradientColorView = {
        let view = GradientColorView()
        view.buildGradientWithColors(gradientColors: [UIColor.init(hexString: "#FABFAB")!, UIColor.init(hexString: "#FFFFFF")!], gradientStyle: .topToBottom)
        return view
    }()
    
    // 埋点使用
    open var buryBeginTime: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.buryBeginTime = Date().jk.dateToTimeStamp()
        
        self.fd_interactivePopDisabled = false
        self.fd_prefersNavigationBarHidden = false
        self.JCAPPbuildViewUI()
        self.JCAPPlayoutControlViews()
    }
    
    deinit {
        deallocPrint()
    }
    
    public func JCAPPbuildViewUI() {
        self.view.addSubview(self.JCAPPgradientView)
        self.view.addSubview(self.JCAPPtopImageView)
        self.view.addSubview(self.JCAPPcontentView)
    }
    
    public func JCAPPlayoutControlViews() {
        
        self.JCAPPtopImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(ScreenWidth * 0.5)
        }
        
        self.JCAPPgradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let _childrenVC = self.navigationController?.children, _childrenVC.count > 1 {
            self.JCAPPcontentView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.top.equalTo(self.view).offset(UIDevice.app_navigationBarAndStatusBarHeight() + APP_PADDING_UNIT)
                make.bottom.equalToSuperview().offset(-UIDevice.app_safeDistanceBottom() - APP_PADDING_UNIT)
            }
        } else {
            if self.presentingViewController != nil {
                self.JCAPPcontentView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else {
                self.JCAPPcontentView.snp.makeConstraints { make in
                    make.horizontalEdges.top.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-UIDevice.app_tabbarAndSafeAreaHeight())
                }
            }
        }
    }
    
    public func JCAPPreloadDeviceLocation() {
        // 获取最新的定位
        DeviceAuthorizationTool.authorization().requestDeviceLocation()
    }
    
    public func JCAPPpageNetowrkRequest() {
        
    }
}
