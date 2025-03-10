//
//  JCAPPLoanCommodityModel.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

class JCAPPLoanCommodityModel: JCAPPBaseNetResponseModel, YYModel {
    
    /// 客服
    var like: JCMainServiceModel?
    /// 走马灯
    var peter: [String]?
    /// 首页数据
    var physicists: [Dictionary<String, Any>]?
    /// 大卡数据
    var bigCard: [VCMainLoanCommodityModel]?
    /// 小卡数据
    var smallCard: [VCMainLoanCommodityModel]?
    /// 产品列表
    var productList: [VCMainLoanCommodityModel]?
    
    public func filterHomeData() {
        guard let _dictArray = self.physicists else {
            return
        }
        
        for item in _dictArray {
            if let _type_str = item["late"] as? String, let _array = item["replaced"] as? NSArray {
                let _type = JCAPPHomeElementType(rawValue: _type_str)
                switch _type {
                case .Banner:
                    break
                case .BigCard:
                    self.bigCard = NSArray.modelArray(with: VCMainLoanCommodityModel.self, json: _array) as? [VCMainLoanCommodityModel]
                case .SmallCard:
                    self.smallCard = NSArray.modelArray(with: VCMainLoanCommodityModel.self, json: _array) as? [VCMainLoanCommodityModel]
                case .ProductList:
                    self.productList = NSArray.modelArray(with: VCMainLoanCommodityModel.self, json: _array) as? [VCMainLoanCommodityModel]
                case .none:
                    break
                }
            }
        }
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["mexican": JCMainServiceModel.self]
    }
}

class JCMainServiceModel: JCAPPBaseNetResponseModel {
    /// 客服手机
    var developed: String?
    /// 客服服务界面
    var mansfield: String?
}

class VCMainLoanCommodityModel: JCAPPBaseNetResponseModel {
    /// 产品ID
    var mouse: String?
    /// 产品名称
    var cavity: String?
    /// 产品logo
    var clam: String?
    /// 申请按钮文案
    var picture: String?
    /// 申请按钮颜色
    var deteriorates: String?
    /// 产品金额
    var followed: String?
    /// 产品金额文案
    var journal: String?
    /// 产品期限
    var tubes: String?
    /// 产品期限文案
    var projection: String?
    /// 产品利率
    var dimensions: String?
    var alterations: String?
    /// 产品利率文案
    var lauterbur: String?
    /// 期限logo
    var paul: String?
    /// 利率logo
    var university: String?
    /// 产品Tag
    var brook: [String]?
    /// 产品描述
    var stony: String?
    /// 产品状态
    var utilize: Int = -1
    /// 产品类型 1 API 2 H5
    var said: Int = 1
    /// 最大额度
    var autopsy: String?
}
