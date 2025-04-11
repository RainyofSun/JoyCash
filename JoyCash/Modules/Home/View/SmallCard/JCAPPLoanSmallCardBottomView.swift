//
//  JCAPPLoanSmallCardBottomView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

protocol APPLoanSmallCardBottomProtocol: AnyObject {
    func didSelectedCommodityModel(_ model: VCMainLoanCommodityModel, sender: APPActivityButton)
}

class JCAPPLoanSmallCardBottomView: UIView {

    weak open var smallDelegate: APPLoanSmallCardBottomProtocol?
    
    private lazy var tipLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.boldSystemFont(ofSize: 18), labelColor: BLACK_COLOR_26264A, labelText: "Loan Supermarket")
    private lazy var smallTableView: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private var _commodity_model: [VCMainLoanCommodityModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.smallTableView.delegate = self
        self.smallTableView.dataSource = self
        self.smallTableView.register(JCAPPLoanSmallCardTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(JCAPPLoanSmallCardTableViewCell.self))
        
        self.addSubview(self.tipLab)
        self.addSubview(self.smallTableView)
        
        self.tipLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 3)
            make.top.equalToSuperview()
        }
        
        self.smallTableView.snp.makeConstraints { make in
            make.top.equalTo(self.tipLab.snp.bottom).offset(APP_PADDING_UNIT)
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
    
    public func reloadSmallCardCommoditySource(_ source: [VCMainLoanCommodityModel]) {
        self._commodity_model.removeAll()
        self._commodity_model.append(contentsOf: source)
        self.smallTableView.reloadData()
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
        
        _cell.reloadRecommendCommodity(self._commodity_model[indexPath.row])
        
        return _cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _cell = tableView.cellForRow(at: indexPath) as? JCAPPLoanSmallCardTableViewCell else {
            return
        }
        
        self.smallDelegate?.didSelectedCommodityModel(self._commodity_model[indexPath.row], sender: _cell.loanBtn)
    }
}
