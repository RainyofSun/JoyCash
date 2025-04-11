//
//  JCAPPCommodityOrderViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPCommodityOrderViewController: JCAPPBaseViewController {

    private lazy var menuView: JCAPPOrderMenuView = JCAPPOrderMenuView(frame: CGRectZero)
    private lazy var allTableView: JCAPPCommodityOrderTableView = JCAPPCommodityOrderTableView(frame: CGRectZero, style: UITableView.Style.plain)
    private var applyTableView: JCAPPCommodityOrderTableView?
    private var repaymentTableView: JCAPPCommodityOrderTableView?
    private var finishTableView: JCAPPCommodityOrderTableView?
    
    override func buildViewUI() {
        super.buildViewUI()
        self.contentView.contentSize = CGSize(width: ScreenWidth * 4, height: .zero)
        self.contentView.isScrollEnabled = false
        
        self.menuView.menuDelegate = self
        self.allTableView.orderDelegate = self
        
        self.allTableView.tag = 104
        self.title = "Order"
        self.view.addSubview(self.menuView)
        self.contentView.addSubview(self.allTableView)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.menuView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(UIDevice.app_navigationBarAndStatusBarHeight() + APP_PADDING_UNIT)
            make.height.equalTo(APP_PADDING_UNIT * 10)
        }
        
        self.contentView.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-UIDevice.app_tabbarAndSafeAreaHeight() - APP_PADDING_UNIT)
            make.top.equalTo(self.menuView.snp.bottom).offset(APP_PADDING_UNIT)
        }
        
        self.allTableView.snp.makeConstraints { make in
            make.top.left.size.equalToSuperview()
        }
    }
    
    public func switchOrderMenu(index: Int) {
        self.menuView.selectedMenuItem(idx: index)
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        switch self.menuView.selectedIndex {
        case 0:
            self.allTableView.refresh(begin: true)
        case 1:
            self.applyTableView?.refresh(begin: true)
        case 2:
            self.repaymentTableView?.refresh(begin: true)
        case 3:
            self.finishTableView?.refresh(begin: true)
        default:
            break
        }
    }
}

extension JCAPPCommodityOrderViewController: APPOrderMenuProtocol {
    func didSeletedMenuItem(idx: Int) {
        switch idx {
        case 0:
            self.allTableView.refresh(begin: true)
        case 1:
            if self.applyTableView == nil {
                let _tab = JCAPPCommodityOrderTableView(frame: CGRect(origin: CGPoint(x: ScreenWidth, y: .zero), size: self.allTableView.size), style: UITableView.Style.plain)
                _tab.tag = 107
                _tab.orderDelegate = self
                self.contentView.addSubview(_tab)
                self.applyTableView = _tab
                _tab.switchOrderTableAndRefresh()
            } else {
                self.applyTableView?.refresh(begin: true)
            }
        case 2:
            if self.repaymentTableView == nil {
                let _tab = JCAPPCommodityOrderTableView(frame: CGRect(origin: CGPoint(x: ScreenWidth * CGFloat(idx), y: .zero), size: self.allTableView.size), style: UITableView.Style.plain)
                _tab.tag = 106
                _tab.orderDelegate = self
                self.contentView.addSubview(_tab)
                self.repaymentTableView = _tab
                _tab.switchOrderTableAndRefresh()
            } else {
                self.repaymentTableView?.refresh(begin: true)
            }
        case 3:
            if self.finishTableView == nil {
                let _tab = JCAPPCommodityOrderTableView(frame: CGRect(origin: CGPoint(x: ScreenWidth * CGFloat(idx), y: .zero), size: self.allTableView.size), style: UITableView.Style.plain)
                _tab.tag = 105
                _tab.orderDelegate = self
                self.contentView.addSubview(_tab)
                self.finishTableView = _tab
                _tab.switchOrderTableAndRefresh()
            } else {
                self.finishTableView?.refresh(begin: true)
            }
        default:
            break
        }
        
        self.contentView.setContentOffset(CGPoint(x: ScreenWidth * CGFloat(idx), y: .zero), animated: true)
    }
}

extension JCAPPCommodityOrderViewController: APPCommodityOrderTableProtocol {
    func startRefreshOrderTable(table: JCAPPCommodityOrderTableView) {
        APPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/raymond", requestParams: ["parameter": "\(table.tag - 100)"])) { (task: URLSessionDataTask, res: APPSuccessResponse) in
            table.refresh(begin: false)
            guard let _dict = res.jsonDict, let _array = _dict["physicists"] as? NSArray, let _models = NSArray.modelArray(with: JCAPPCommodityOrderModel.self, json: _array) as? [JCAPPCommodityOrderModel] else {
                return
            }
            
            table.refreshCommodityOrderTable(data: _models)
        } failure: { _, _ in
            table.refresh(begin: false)
        }
    }
    
    func didSelectedOrderTableItem(orderItemModel: JCAPPCommodityOrderModel) {
        guard let _url = orderItemModel.acquiring else {
            return
        }
        
        JCAPPPageRouting.shared.JoyCashPageRouter(routeUrl: _url, backToRoot: _url.hasPrefix("http"))
    }
}
