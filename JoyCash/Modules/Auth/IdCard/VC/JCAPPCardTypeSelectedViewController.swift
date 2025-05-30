//
//  JCAPPCardTypeSelectedViewController.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/26.
//

import UIKit

protocol CardTypeSelectedProtocol: AnyObject {
    func JCAPPdidSelectedCardType(cardType: String?)
}

class JCAPPCardTypeSelectedViewController: JCAPPCommodityAuthViewController {

    weak open var typeDelegate: CardTypeSelectedProtocol?
    
    private lazy var JCAPPcardTypeTable: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.grouped)
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var JCAPP_card_types: [JCCardTypeStruct] = []
    private var JCAPP_select_card_type: String?
    
    init(certificationTitle title: String?, cardTypes: [[String]], delegate: CardTypeSelectedProtocol?) {
        super.init(certificationTitle: title)
        self.typeDelegate = delegate
        self.JCAPP_card_types = JCCardTypeStruct.conbineModels(data: cardTypes)
    }
    
    override func JCAPPbuildViewUI() {
        super.JCAPPbuildViewUI()
        
        self.JCAPPcardTypeTable.delegate = self
        self.JCAPPcardTypeTable.dataSource = self
        self.JCAPPcardTypeTable.register(JCAPPCardTypeTableViewCell.self, forCellReuseIdentifier: JCAPPCardTypeTableViewCell.className())
        self.JCAPPcardTypeTable.register(JCAPPCardTypeTableHeader.self, forHeaderFooterViewReuseIdentifier: JCAPPCardTypeTableHeader.className())
        
        self.JCAPPcontainerView.addSubview(self.JCAPPcardTypeTable)
        self.JCAPPsetTipWithTitle(String.JCAPP_owpleiString(), subTitle: String.JCAPP_yueuridString())
    }
    
    override func JCAPPlayoutControlViews() {
        super.JCAPPlayoutControlViews()
        
        self.JCAPPcardTypeTable.snp.makeConstraints { make in
            make.top.equalTo(self.JCAPPcontentLab.snp.bottom).offset(APP_PADDING_UNIT * 5)
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 4)
            make.height.equalTo(ScreenHeight * 0.6)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT * 2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}

extension JCAPPCardTypeSelectedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.JCAPP_card_types.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = self.JCAPP_card_types[section]
        return sectionModel.isExpand ? self.JCAPP_card_types[section].content?.count ?? .zero : .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: JCAPPCardTypeTableViewCell.className(), for: indexPath) as? JCAPPCardTypeTableViewCell else {
            return UITableViewCell()
        }
        
        if let _contentArray = self.JCAPP_card_types[indexPath.section].content {
            _cell.reloadTypeTitie(_contentArray[indexPath.row])
        }
        
        return _cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: JCAPPCardTypeTableHeader.className()) as? JCAPPCardTypeTableHeader else {
            return nil
        }
        
        header.JCAPPreloadHeaderTitle(self.JCAPP_card_types[section].sectionTitle, isExpand: self.JCAPP_card_types[section].isExpand)
        header.clickHeaderClousre = { [weak self] in
            guard let _self = self else {
                return
            }
            _self.JCAPP_card_types[section].isExpand = !_self.JCAPP_card_types[section].isExpand
            tableView.beginUpdates()
            tableView.reloadSections([section], with: .fade)
            tableView.endUpdates()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        self.typeDelegate?.JCAPPdidSelectedCardType(cardType: self.JCAPP_card_types[indexPath.section].content?[indexPath.row])
    }
}
