//
//  JCAPPCommodityOrderViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPCommodityOrderViewController: JCAPPBaseViewController {

    private lazy var menuView: JCAPPOrderMenuView = JCAPPOrderMenuView(frame: CGRectZero)
    private lazy var JCAPPallTableView: JCAPPCommodityOrderTableView = JCAPPCommodityOrderTableView(frame: CGRectZero, style: UITableView.Style.plain)
    private var JCAPPapplyTableView: JCAPPCommodityOrderTableView?
    private var JCAPPrepaymentTableView: JCAPPCommodityOrderTableView?
    private var JCAPPfinishTableView: JCAPPCommodityOrderTableView?
    
    override func JCAPPbuildViewUI() {
        super.JCAPPbuildViewUI()
        self.JCAPPcontentView.contentSize = CGSize(width: ScreenWidth * 4, height: .zero)
        self.JCAPPcontentView.isScrollEnabled = false
        
        self.menuView.menuDelegate = self
        self.JCAPPallTableView.orderDelegate = self
        
        self.JCAPPallTableView.tag = 104
        self.title = "Order"
        self.view.addSubview(self.menuView)
        self.JCAPPcontentView.addSubview(self.JCAPPallTableView)
    }
    
    override func JCAPPlayoutControlViews() {
        super.JCAPPlayoutControlViews()
        
        self.menuView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(UIDevice.app_navigationBarAndStatusBarHeight() + APP_PADDING_UNIT)
            make.height.equalTo(APP_PADDING_UNIT * 10)
        }
        
        self.JCAPPcontentView.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-UIDevice.app_tabbarAndSafeAreaHeight() - APP_PADDING_UNIT)
            make.top.equalTo(self.menuView.snp.bottom).offset(APP_PADDING_UNIT)
        }
        
        self.JCAPPallTableView.snp.makeConstraints { make in
            make.top.left.size.equalToSuperview()
        }
    }
    
    public func JCAPPswitchOrderMenu(index: Int) {
        self.menuView.JCAPPselectedMenuItem(idx: index)
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        switch self.menuView.selectedIndex {
        case 0:
            self.JCAPPallTableView.refresh(begin: true)
        case 1:
            self.JCAPPapplyTableView?.refresh(begin: true)
        case 2:
            self.JCAPPrepaymentTableView?.refresh(begin: true)
        case 3:
            self.JCAPPfinishTableView?.refresh(begin: true)
        default:
            break
        }
    }
}

extension JCAPPCommodityOrderViewController: APPOrderMenuProtocol {
    func didSeletedMenuItem(idx: Int) {
        switch idx {
        case 0:
            self.JCAPPallTableView.refresh(begin: true)
        case 1:
            if self.JCAPPapplyTableView == nil {
                let _tab = JCAPPCommodityOrderTableView(frame: CGRect(origin: CGPoint(x: ScreenWidth, y: .zero), size: self.JCAPPallTableView.size), style: UITableView.Style.plain)
                _tab.tag = 107
                _tab.orderDelegate = self
                self.JCAPPcontentView.addSubview(_tab)
                self.JCAPPapplyTableView = _tab
                _tab.JCAPPswitchOrderTableAndRefresh()
            } else {
                self.JCAPPapplyTableView?.refresh(begin: true)
            }
        case 2:
            if self.JCAPPrepaymentTableView == nil {
                let _tab = JCAPPCommodityOrderTableView(frame: CGRect(origin: CGPoint(x: ScreenWidth * CGFloat(idx), y: .zero), size: self.JCAPPallTableView.size), style: UITableView.Style.plain)
                _tab.tag = 106
                _tab.orderDelegate = self
                self.JCAPPcontentView.addSubview(_tab)
                self.JCAPPrepaymentTableView = _tab
                _tab.JCAPPswitchOrderTableAndRefresh()
            } else {
                self.JCAPPrepaymentTableView?.refresh(begin: true)
            }
        case 3:
            if self.JCAPPfinishTableView == nil {
                let _tab = JCAPPCommodityOrderTableView(frame: CGRect(origin: CGPoint(x: ScreenWidth * CGFloat(idx), y: .zero), size: self.JCAPPallTableView.size), style: UITableView.Style.plain)
                _tab.tag = 105
                _tab.orderDelegate = self
                self.JCAPPcontentView.addSubview(_tab)
                self.JCAPPfinishTableView = _tab
                _tab.JCAPPswitchOrderTableAndRefresh()
            } else {
                self.JCAPPfinishTableView?.refresh(begin: true)
            }
        default:
            break
        }
        
        self.JCAPPcontentView.setContentOffset(CGPoint(x: ScreenWidth * CGFloat(idx), y: .zero), animated: true)
    }
}

extension JCAPPCommodityOrderViewController: APPCommodityOrderTableProtocol {
    func JCAPPstartRefreshOrderTable(table: JCAPPCommodityOrderTableView) {
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/raymond", requestParams: ["parameter": "\(table.tag - 100)"])) { (task: URLSessionDataTask, res: APPSuccessResponse) in
            table.refresh(begin: false)
            guard let _dict = res.jsonDict, let _array = _dict["physicists"] as? NSArray, let _models = NSArray.modelArray(with: JCAPPCommodityOrderModel.self, json: _array) as? [JCAPPCommodityOrderModel] else {
                return
            }
            
            table.JCAPPrefreshCommodityOrderTable(data: _models)
        } failure: { _, _ in
            table.refresh(begin: false)
        }
    }
    
    func JCAPPdidSelectedOrderTableItem(orderItemModel: JCAPPCommodityOrderModel) {
        guard let _url = orderItemModel.acquiring else {
            return
        }
        
        JCAPPPageRouting.shared.JCAPPJoyCashPageRouter(routeUrl: _url, backToRoot: _url.hasPrefix("http"))
    }
}
