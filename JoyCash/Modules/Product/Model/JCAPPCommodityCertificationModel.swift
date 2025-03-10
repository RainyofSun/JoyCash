//
//  JCAPPCommodityCertificationModel.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit

class JCAPPCommodityCertificationModel: JCAPPBaseNetResponseModel {
    /// 产品信息
    var hyperacusis: JCAPPCommodityModel?
    /// 认证列表
    var peripheral: [JCAPPAuthorizationModel]?
    /// 待认证项
    var generally: JCAPPWaitCertificationModel?
    /// 协议
    var chemicals: JCAPPCommonValueModel?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["hyperacusis": JCAPPCommodityModel.self, "peripheral": JCAPPAuthorizationModel.self,
                "generally": JCAPPWaitCertificationModel.self, "chemicals": JCAPPCommonValueModel.self]
    }
}

class JCAPPCommodityModel: JCAPPBaseNetResponseModel, YYModel {
    /// 借款期限
    var speeds: String?
    /// 借款期限文案
    var machines: String?
    /// 期限类型
    var powerful: Int = -1
    /// 产品金额
    var hearing: String?
    /// 借款金额文案
    var loud: String?
    /// 产品ID
    var mouse: String?
    /// 产品名称
    var cavity: String?
    /// 产品logo
    var clam: String?
    /// 订单号
    var fatalities: String?
    /// 订单ID
    var globally: String?
    /// 额外信息
    var millions: JCAPPCommodityExtensionInfo?
    /// 底部按钮文案
    var picture: String?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["millions": JCAPPCommodityExtensionInfo.self]
    }
}

class JCAPPCommodityExtensionInfo: JCAPPBaseNetResponseModel, YYModel {
    var accidents: JCAPPCommonValueModel?
    var projectile: JCAPPCommonValueModel?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["accidents": JCAPPCommonValueModel.self, "projectile": JCAPPCommonValueModel.self]
    }
}

class JCAPPWaitCertificationModel: JCAPPBaseNetResponseModel {
    var sedation: String?
    /// 标题
    var graphic: String?
    /// 有值时跳转H5
    var zeugmatography: String?
    var certificationType: JCAPPCertificationType? {
        return JCAPPCertificationType(rawValue: self.sedation ?? "")
    }
}

class JCAPPAuthorizationModel: JCAPPBaseNetResponseModel {
    /// 标题
    var graphic: String?
    /// 占位文字
    var amplitude: String?
    /// 是否完成
    var protocols: Bool = false
    /// 类型 【重要】用作判断,根据该字段判断跳转对应页面
    var sedation: String?
    var certificationType: JCAPPCertificationType {
        return JCAPPCertificationType(rawValue: self.sedation ?? "") ?? .Certification_ID_Card
    }
    /// 图片地址
    var fossils: String?
}
