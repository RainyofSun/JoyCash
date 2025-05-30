//
//  JCAPPSelectCityPickerPopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/26.
//

import UIKit

class JCAPPSelectCityPickerCell: UITableViewCell {
    
    private lazy var bgImgView: UIImageView = UIImageView(image: UIImage(named: "pop_city_bg"))
    private lazy var JCAPPcontentLab: UILabel = UILabel.JCAPPbuildJoyCashLabel(font: UIFont.systemFont(ofSize: 16), labelColor: BLACK_COLOR_26264A)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        self.selectionStyle = .none
        
        self.JCAPPcontentLab.textAlignment = .left
        self.bgImgView.isHidden = true
        
        self.contentView.addSubview(self.bgImgView)
        self.contentView.addSubview(self.JCAPPcontentLab)
        
        self.bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.JCAPPcontentLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 6)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.bgImgView.isHidden = !selected
    }
    
    deinit {
        deallocPrint()
    }
    
    public func JCAPPreloadContent(_ title: String?) {
        self.JCAPPcontentLab.text = title
    }
}

class JCAPPSelectCityPickerPopView: JCAPPBasePopView {

    open var select_city: String = ""
    
    private lazy var hScrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRectZero)
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.isScrollEnabled = false
        return view
    }()
    
    private lazy var JCAPPleftBtn: UIButton = UIButton.JCAPPbuildJoyCashNormalButton("Country", titleFont: UIFont.systemFont(ofSize: 16), titleColor: BLACK_COLOR_26264A)
    private lazy var midBtn: UIButton = UIButton.JCAPPbuildJoyCashNormalButton(titleFont: UIFont.systemFont(ofSize: 16), titleColor: BLACK_COLOR_26264A)
    private lazy var rightBtn: UIButton = UIButton.JCAPPbuildJoyCashNormalButton(titleFont: UIFont.systemFont(ofSize: 16), titleColor: BLACK_COLOR_26264A)
    
    private lazy var JCAPPleftTable: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        view.separatorStyle = .none
        return view
    }()
    
    private lazy var JCAPPmidTable: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        view.separatorStyle = .none
        return view
    }()
    
    private lazy var JCAPPrightTable: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        view.separatorStyle = .none
        return view
    }()
    
    private let JCAPPcontent_size_width = ScreenWidth - APP_PADDING_UNIT * 28
    private var JCAPP_left_city_array: [JCAPPCityModel] = []
    private var JCAPP_mid_city_array: [JCAPPCityModel] = []
    private var JCAPP_right_city_array: [JCAPPCityModel] = []
    
    private var JCAPP_has_select_all_city: Bool = false
    
    override func JCAPPbuildPopViews() {
        super.JCAPPbuildPopViews()
        
        self.hScrollView.contentSize = CGSize(width: JCAPPcontent_size_width * 3, height: .zero)
        
        self.JCAPPleftBtn.tag = 1000
        self.midBtn.tag = 1001
        self.rightBtn.tag = 1002
        
        self.JCAPPleftBtn.addTarget(self, action: #selector(JCAPPswicthCityList(sender: )), for: UIControl.Event.touchUpInside)
        self.midBtn.addTarget(self, action: #selector(JCAPPswicthCityList(sender: )), for: UIControl.Event.touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(JCAPPswicthCityList(sender: )), for: UIControl.Event.touchUpInside)
        
        self.JCAPPleftTable.register(JCAPPSelectCityPickerCell.self, forCellReuseIdentifier: JCAPPSelectCityPickerCell.className())
        self.JCAPPmidTable.register(JCAPPSelectCityPickerCell.self, forCellReuseIdentifier: JCAPPSelectCityPickerCell.className())
        self.JCAPPrightTable.register(JCAPPSelectCityPickerCell.self, forCellReuseIdentifier: JCAPPSelectCityPickerCell.className())
        
        self.JCAPPleftTable.delegate = self
        self.JCAPPleftTable.dataSource = self
        self.JCAPPmidTable.delegate = self
        self.JCAPPmidTable.dataSource = self
        self.JCAPPrightTable.delegate = self
        self.JCAPPrightTable.dataSource = self
        
        self.JCAPPcontentView.addSubview(self.JCAPPleftBtn)
        self.JCAPPcontentView.addSubview(self.midBtn)
        self.JCAPPcontentView.addSubview(self.rightBtn)
        self.JCAPPcontentView.addSubview(self.hScrollView)
        self.hScrollView.addSubview(self.JCAPPleftTable)
        self.hScrollView.addSubview(self.JCAPPmidTable)
        self.hScrollView.addSubview(self.JCAPPrightTable)
        
        if FileManager.default.fileExists(atPath: JCAPPPublic.shared.JCAPPcityFilePath) {
            let _models = JCAPPLoanCityModel.readCityModelsFormDisk()
            if !_models.isEmpty {
                self.JCAPP_left_city_array = _models
                self.JCAPPleftTable.reloadData()
            }
        }
    }
    
    override func JCAPPlayoutPopViews() {
        super.JCAPPlayoutPopViews()
        self.JCAPPleftBtn.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.midBtn.snp.makeConstraints { make in
            make.left.equalTo(self.JCAPPleftBtn.snp.right)
            make.top.size.equalTo(self.JCAPPleftBtn)
        }
        
        self.rightBtn.snp.makeConstraints { make in
            make.left.equalTo(self.midBtn.snp.right)
            make.top.size.equalTo(self.midBtn)
            make.right.equalToSuperview()
        }
        
        self.hScrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 6)
            make.top.equalTo(self.JCAPPleftBtn.snp.bottom)
            make.height.equalTo(250)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
        }
        
        self.JCAPPleftTable.snp.makeConstraints { make in
            make.left.top.height.equalToSuperview()
            make.width.equalTo(JCAPPcontent_size_width)
        }
        
        self.JCAPPmidTable.snp.makeConstraints { make in
            make.left.equalTo(self.JCAPPleftTable.snp.right)
            make.top.size.equalTo(self.JCAPPleftTable)
        }
        
        self.JCAPPrightTable.snp.makeConstraints { make in
            make.left.equalTo(self.JCAPPmidTable.snp.right)
            make.size.top.equalTo(self.JCAPPmidTable)
        }
    }
    
    override func JCAPPclickConfirmButton(sender: APPActivityButton) {
        guard self.JCAPP_has_select_all_city else {
            self.makeToast(String.JCAPP_ioslujkdkString())
            return
        }
        
        super.JCAPPclickConfirmButton(sender: sender)
    }
    
    public override class func JCAPPconvenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
        let view = JCAPPSelectCityPickerPopView(frame: UIScreen.main.bounds, showCloseButton: show)
        view.alpha = .zero
        superView.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        return view as! Self
    }
}

extension JCAPPSelectCityPickerPopView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.JCAPPleftTable {
            return JCAPP_left_city_array.count
        } else if tableView == self.JCAPPmidTable {
            return JCAPP_mid_city_array.count
        } else if tableView == self.JCAPPrightTable {
            return JCAPP_right_city_array.count
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: JCAPPSelectCityPickerCell.className(), for: indexPath) as? JCAPPSelectCityPickerCell else {
            return UITableViewCell()
        }
        
        if tableView == self.JCAPPleftTable {
            _cell.JCAPPreloadContent(self.JCAPP_left_city_array[indexPath.row].foreign)
        } else if tableView == self.JCAPPmidTable {
            _cell.JCAPPreloadContent(self.JCAPP_mid_city_array[indexPath.row].foreign)
        } else if tableView == self.JCAPPrightTable {
            _cell.JCAPPreloadContent(self.JCAPP_right_city_array[indexPath.row].foreign)
        }
        
        return _cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.JCAPPleftTable {
            self.JCAPPleftBtn.setTitle(self.JCAPP_left_city_array[indexPath.row].foreign, for: UIControl.State.normal)
            self.JCAPPleftBtn.setTitleColor(JCAPP_ORANGE_COLOR_F68941, for: UIControl.State.normal)
            self.midBtn.setTitle("City", for: UIControl.State.normal)
            self.midBtn.setTitleColor(BLACK_COLOR_26264A, for: UIControl.State.normal)
            self.rightBtn.setTitle(nil, for: UIControl.State.normal)
            self.rightBtn.setTitleColor(BLACK_COLOR_26264A, for: UIControl.State.normal)
            
            if let _second_city = self.JCAPP_left_city_array[indexPath.row].physicists {
                self.JCAPP_mid_city_array = _second_city
                self.JCAPPmidTable.reloadData()
            }
            
            self.JCAPPswicthCityList(sender: self.midBtn)
            
            self.select_city = self.JCAPPleftBtn.currentTitle ?? ""
            self.JCAPP_has_select_all_city = false
        }
        
        if tableView == self.JCAPPmidTable {
            self.midBtn.setTitle(self.JCAPP_mid_city_array[indexPath.row].foreign, for: UIControl.State.normal)
            self.midBtn.setTitleColor(JCAPP_ORANGE_COLOR_F68941, for: UIControl.State.normal)
            self.rightBtn.setTitle("Area", for: UIControl.State.normal)
            self.rightBtn.setTitleColor(BLACK_COLOR_26264A, for: UIControl.State.normal)
            if let _last_city = self.JCAPP_mid_city_array[indexPath.row].physicists {
                self.JCAPP_right_city_array = _last_city
                self.JCAPPrightTable.reloadData()
            }
            
            self.JCAPPswicthCityList(sender: self.rightBtn)
            
            self.select_city += (" | " + (self.midBtn.currentTitle ?? ""))
            self.JCAPP_has_select_all_city = false
        }
        
        if tableView == self.JCAPPrightTable {
            self.rightBtn.setTitle(self.JCAPP_right_city_array[indexPath.row].foreign, for: UIControl.State.normal)
            self.rightBtn.setTitleColor(JCAPP_ORANGE_COLOR_F68941, for: UIControl.State.normal)
            
            self.select_city += (" | " + (self.rightBtn.currentTitle ?? ""))
            self.JCAPP_has_select_all_city = true
        }
        
        guard let _cell = tableView.cellForRow(at: indexPath) as? JCAPPSelectCityPickerCell else {
            return
        }
        
        _cell.setSelected(true, animated: true)
    }
}

// MARK: Target
@objc private extension JCAPPSelectCityPickerPopView {
    func JCAPPswicthCityList(sender: UIButton) {
        self.hScrollView.setContentOffset(CGPoint(x: JCAPPcontent_size_width * CGFloat(sender.tag - 1000), y: .zero), animated: true)
    }
}
