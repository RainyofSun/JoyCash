//
//  JCAPPSelectCityPickerPopView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/26.
//

import UIKit

class JCAPPSelectCityPickerCell: UITableViewCell {
    
    private lazy var bgImgView: UIImageView = UIImageView(image: UIImage(named: "pop_city_bg"))
    private lazy var contentLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.systemFont(ofSize: 16), labelColor: BLACK_COLOR_26264A)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        self.selectionStyle = .none
        
        self.contentLab.textAlignment = .left
        self.bgImgView.isHidden = true
        
        self.contentView.addSubview(self.bgImgView)
        self.contentView.addSubview(self.contentLab)
        
        self.bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.contentLab.snp.makeConstraints { make in
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
    
    public func reloadContent(_ title: String?) {
        self.contentLab.text = title
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
    
    private lazy var leftBtn: UIButton = UIButton.buildJoyCashNormalButton("Country", titleFont: UIFont.systemFont(ofSize: 16), titleColor: BLACK_COLOR_26264A)
    private lazy var midBtn: UIButton = UIButton.buildJoyCashNormalButton(titleFont: UIFont.systemFont(ofSize: 16), titleColor: BLACK_COLOR_26264A)
    private lazy var rightBtn: UIButton = UIButton.buildJoyCashNormalButton(titleFont: UIFont.systemFont(ofSize: 16), titleColor: BLACK_COLOR_26264A)
    
    private lazy var leftTable: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        view.separatorStyle = .none
        return view
    }()
    
    private lazy var midTable: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        view.separatorStyle = .none
        return view
    }()
    
    private lazy var rightTable: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        view.separatorStyle = .none
        return view
    }()
    
    private let content_size_width = ScreenWidth - APP_PADDING_UNIT * 28
    private var _left_city_array: [JCAPPCityModel] = []
    private var _mid_city_array: [JCAPPCityModel] = []
    private var _right_city_array: [JCAPPCityModel] = []
    
    private var _has_select_all_city: Bool = false
    
    override func buildPopViews() {
        super.buildPopViews()
        
        self.hScrollView.contentSize = CGSize(width: content_size_width * 3, height: .zero)
        
        self.leftBtn.tag = 1000
        self.midBtn.tag = 1001
        self.rightBtn.tag = 1002
        
        self.leftBtn.addTarget(self, action: #selector(swicthCityList(sender: )), for: UIControl.Event.touchUpInside)
        self.midBtn.addTarget(self, action: #selector(swicthCityList(sender: )), for: UIControl.Event.touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(swicthCityList(sender: )), for: UIControl.Event.touchUpInside)
        
        self.leftTable.register(JCAPPSelectCityPickerCell.self, forCellReuseIdentifier: JCAPPSelectCityPickerCell.className())
        self.midTable.register(JCAPPSelectCityPickerCell.self, forCellReuseIdentifier: JCAPPSelectCityPickerCell.className())
        self.rightTable.register(JCAPPSelectCityPickerCell.self, forCellReuseIdentifier: JCAPPSelectCityPickerCell.className())
        
        self.leftTable.delegate = self
        self.leftTable.dataSource = self
        self.midTable.delegate = self
        self.midTable.dataSource = self
        self.rightTable.delegate = self
        self.rightTable.dataSource = self
        
        self.contentView.addSubview(self.leftBtn)
        self.contentView.addSubview(self.midBtn)
        self.contentView.addSubview(self.rightBtn)
        self.contentView.addSubview(self.hScrollView)
        self.hScrollView.addSubview(self.leftTable)
        self.hScrollView.addSubview(self.midTable)
        self.hScrollView.addSubview(self.rightTable)
        
        if FileManager.default.fileExists(atPath: JCAPPPublic.shared.cityFilePath) {
            let _models = JCAPPLoanCityModel.readCityModelsFormDisk()
            if !_models.isEmpty {
                self._left_city_array = _models
                self.leftTable.reloadData()
            }
        }
    }
    
    override func layoutPopViews() {
        super.layoutPopViews()
        self.leftBtn.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.midBtn.snp.makeConstraints { make in
            make.left.equalTo(self.leftBtn.snp.right)
            make.top.size.equalTo(self.leftBtn)
        }
        
        self.rightBtn.snp.makeConstraints { make in
            make.left.equalTo(self.midBtn.snp.right)
            make.top.size.equalTo(self.midBtn)
            make.right.equalToSuperview()
        }
        
        self.hScrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 6)
            make.top.equalTo(self.leftBtn.snp.bottom)
            make.height.equalTo(250)
            make.bottom.equalToSuperview().offset(-APP_PADDING_UNIT)
        }
        
        self.leftTable.snp.makeConstraints { make in
            make.left.top.height.equalToSuperview()
            make.width.equalTo(content_size_width)
        }
        
        self.midTable.snp.makeConstraints { make in
            make.left.equalTo(self.leftTable.snp.right)
            make.top.size.equalTo(self.leftTable)
        }
        
        self.rightTable.snp.makeConstraints { make in
            make.left.equalTo(self.midTable.snp.right)
            make.size.top.equalTo(self.midTable)
        }
    }
    
    override func clickConfirmButton(sender: JCAPPActivityButton) {
        guard self._has_select_all_city else {
            self.makeToast("Please verify your address")
            return
        }
        
        super.clickConfirmButton(sender: sender)
    }
    
    public override class func convenienceShowPop(_ superView: UIView, showCloseButton show: Bool = false) -> Self {
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
        if tableView == self.leftTable {
            return _left_city_array.count
        } else if tableView == self.midTable {
            return _mid_city_array.count
        } else if tableView == self.rightTable {
            return _right_city_array.count
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: JCAPPSelectCityPickerCell.className(), for: indexPath) as? JCAPPSelectCityPickerCell else {
            return UITableViewCell()
        }
        
        if tableView == self.leftTable {
            _cell.reloadContent(self._left_city_array[indexPath.row].foreign)
        } else if tableView == self.midTable {
            _cell.reloadContent(self._mid_city_array[indexPath.row].foreign)
        } else if tableView == self.rightTable {
            _cell.reloadContent(self._right_city_array[indexPath.row].foreign)
        }
        
        return _cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.leftTable {
            self.leftBtn.setTitle(self._left_city_array[indexPath.row].foreign, for: UIControl.State.normal)
            self.leftBtn.setTitleColor(BLUE_COLOR_4169F6, for: UIControl.State.normal)
            self.midBtn.setTitle("City", for: UIControl.State.normal)
            self.midBtn.setTitleColor(BLACK_COLOR_26264A, for: UIControl.State.normal)
            self.rightBtn.setTitle(nil, for: UIControl.State.normal)
            self.rightBtn.setTitleColor(BLACK_COLOR_26264A, for: UIControl.State.normal)
            
            if let _second_city = self._left_city_array[indexPath.row].physicists {
                self._mid_city_array = _second_city
                self.midTable.reloadData()
            }
            
            self.swicthCityList(sender: self.midBtn)
            
            self.select_city = self.leftBtn.currentTitle ?? ""
            self._has_select_all_city = false
        }
        
        if tableView == self.midTable {
            self.midBtn.setTitle(self._mid_city_array[indexPath.row].foreign, for: UIControl.State.normal)
            self.midBtn.setTitleColor(BLUE_COLOR_4169F6, for: UIControl.State.normal)
            self.rightBtn.setTitle("Area", for: UIControl.State.normal)
            self.rightBtn.setTitleColor(BLACK_COLOR_26264A, for: UIControl.State.normal)
            if let _last_city = self._mid_city_array[indexPath.row].physicists {
                self._right_city_array = _last_city
                self.rightTable.reloadData()
            }
            
            self.swicthCityList(sender: self.rightBtn)
            
            self.select_city += (" | " + (self.midBtn.currentTitle ?? ""))
            self._has_select_all_city = false
        }
        
        if tableView == self.rightTable {
            self.rightBtn.setTitle(self._right_city_array[indexPath.row].foreign, for: UIControl.State.normal)
            self.rightBtn.setTitleColor(BLUE_COLOR_4169F6, for: UIControl.State.normal)
            
            self.select_city += (" | " + (self.rightBtn.currentTitle ?? ""))
            self._has_select_all_city = true
        }
        
        guard let _cell = tableView.cellForRow(at: indexPath) as? JCAPPSelectCityPickerCell else {
            return
        }
        
        _cell.setSelected(true, animated: true)
    }
}

// MARK: Target
@objc private extension JCAPPSelectCityPickerPopView {
    func swicthCityList(sender: UIButton) {
        self.hScrollView.setContentOffset(CGPoint(x: content_size_width * CGFloat(sender.tag - 1000), y: .zero), animated: true)
    }
}
