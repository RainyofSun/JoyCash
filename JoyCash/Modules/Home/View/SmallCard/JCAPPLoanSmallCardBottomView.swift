//
//  JCAPPLoanSmallCardBottomView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

protocol APPLoanSmallCardBottomProtocol: AnyObject {
    func JCAPPdidSelectedCommodityModel(_ model: VCMainLoanCommodityModel, sender: APPActivityButton)
}

class JCAPPLoanSmallCardBottomView: UIView {

    weak open var smallDelegate: APPLoanSmallCardBottomProtocol?
    
    private lazy var JCAPPtipLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.boldSystemFont(ofSize: 18), labelColor: UIColor.white, labelText: String.JCAPP_bhsuaklalsddaksjdString())
    private lazy var JCAPPsmallTableView: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private var _commodity_model: [VCMainLoanCommodityModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.JCAPPsmallTableView.delegate = self
        self.JCAPPsmallTableView.dataSource = self
        self.JCAPPsmallTableView.register(JCAPPLoanSmallCardTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(JCAPPLoanSmallCardTableViewCell.self))
        
        self.addSubview(self.JCAPPtipLab)
        self.addSubview(self.JCAPPsmallTableView)
        
        self.JCAPPtipLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 4)
            make.top.equalToSuperview()
        }
        
        self.JCAPPsmallTableView.snp.makeConstraints { make in
            make.top.equalTo(self.JCAPPtipLab.snp.bottom).offset(APP_PADDING_UNIT)
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 3)
            make.height.equalTo(ScreenHeight * 0.35)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func JCAPPreloadSmallCardCommoditySource(_ source: [VCMainLoanCommodityModel]) {
        self._commodity_model.removeAll()
        self._commodity_model.append(contentsOf: source)
        self.JCAPPsmallTableView.reloadData()
    }
}

extension JCAPPLoanSmallCardBottomView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._commodity_model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(JCAPPLoanSmallCardTableViewCell.self), for: indexPath) as? JCAPPLoanSmallCardTableViewCell else {
            return UITableViewCell()
        }
        
        _cell.JCAPPreloadRecommendCommodity(self._commodity_model[indexPath.row])
        
        return _cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _cell = tableView.cellForRow(at: indexPath) as? JCAPPLoanSmallCardTableViewCell else {
            return
        }
        
        self.smallDelegate?.JCAPPdidSelectedCommodityModel(self._commodity_model[indexPath.row], sender: _cell.JCAPPloanBtn)
    }
}
