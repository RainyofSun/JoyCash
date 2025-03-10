//
//  JCAPPCommodityOrderTableView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
import EmptyDataSet_Swift

protocol APPCommodityOrderTableProtocol: AnyObject {
    /// 开始请求数据
    func startRefreshOrderTable(table: JCAPPCommodityOrderTableView)
    /// 选中商品
    func didSelectedOrderTableItem(orderItemModel: JCAPPCommodityOrderModel)
}

class JCAPPCommodityOrderTableView: UITableView {

    weak open var orderDelegate: APPCommodityOrderTableProtocol?
    
    private var _commodityModels: [JCAPPCommodityOrderModel] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.separatorStyle = .none
        self.backgroundColor = .clear
        self.register(JCAPPCommodityOrderTableViewCell.self, forCellReuseIdentifier: JCAPPCommodityOrderTableViewCell.className())
        self.delegate = self
        self.dataSource = self
        self.emptyDataSetSource = self
        self.emptyDataSetDelegate = self
        
        self.addMJRefresh(addFooter: false) { [weak self] (refresh: Bool) in
            guard let _self = self else {
                return
            }
            _self.orderDelegate?.startRefreshOrderTable(table: _self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    /// 刷新页面数据
    public func refreshCommodityOrderTable(data: [JCAPPCommodityOrderModel]) {
        self._commodityModels.removeAll()
        self._commodityModels.append(contentsOf: data)
        self.reloadData()
    }
    
    /// 开始刷新
    public func startRefreshCommodity(refresh: Bool) {
        self.refresh(begin: refresh)
    }
    
    /// 切换列表刷新
    public func switchOrderTableAndRefresh() {
        guard self._commodityModels.isEmpty else {
            return
        }
        
        self.refresh(begin: true)
    }
}

extension JCAPPCommodityOrderTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._commodityModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: JCAPPCommodityOrderTableViewCell.className(), for: indexPath) as? JCAPPCommodityOrderTableViewCell else {
            return UITableViewCell()
        }
        
        _cell.reloadCommodityCellSource(self._commodityModels[indexPath.row])
        
        return _cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.orderDelegate?.didSelectedOrderTableItem(orderItemModel: self._commodityModels[indexPath.row])
    }
}

extension JCAPPCommodityOrderTableView: EmptyDataSetDelegate, EmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "order_empty")
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}
