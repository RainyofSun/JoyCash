//
//  JCAPPCardTypeTableViewCell.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/26.
//

import UIKit

class JCAPPCardTypeTableViewCell: UITableViewCell {

    private lazy var titleLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.systemFont(ofSize: 15), labelColor: UIColor.hexStringColor(hexString: "#202020"))
    private lazy var arrowImgView: UIImageView = UIImageView(image: UIImage(named: "mine_arrow"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.arrowImgView)
        
        self.titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(APP_PADDING_UNIT * 4)
        }
        
        self.arrowImgView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 2)
            make.right.equalToSuperview().offset(-APP_PADDING_UNIT * 2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadTypeTitie(_ title: String?) {
        self.titleLab.text = title
    }
}
