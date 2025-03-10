//
//  JCAPPCommodityOrderModel.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

class JCAPPCommodityOrderModel: JCAPPBaseNetResponseModel {
    /// 订单ID
    var globally: String?
    /// 产品名称
    var cavity: String?
    /// 产品logo
    var clam: String?
    /// 订单状态
    var accurate: String?
    /// 状态名称
    var picture: String?
    /// 订单描述
    var variations: String?
    /// 借款金额
    var relative: String?
    /// 跳转地址
    var acquiring: String?
    /// 日期文案
    var interpretation: String?
    /// 额度文案
    var qualitative: String?
    /// 展期日期
    var focuses: String?
    /// 逾期天数
    var routinely: Int = -1
    /// 是否放款
    var channels: Int = -1
    /// 借款时间
    var receiver: String?
    /// 应还时间
    var expansion: String?
    /// 借款期限
    var speeds: String?
    /// 订单列表显示数据
    var rapid: [JCAPPCommonValueModel]?
    /// 借款协议展示文案
    var resulted: String?
    /// 协议地址
    var advent: String?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["rapid": JCAPPCommonValueModel.self]
    }
}
