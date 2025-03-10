//
//  JCAPPAuthInfoUnitModel.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/25.
//

import UIKit

class JCAPPAuthInfoUnitModel: JCAPPBaseNetResponseModel, YYModel {
    /// 标题
    var graphic: String?
    /// 占位文字文案
    var amplitude: String?
    /// key
    var prize: String?
    /// 输入类型
    var defects: String?
    var inputType: JCInputViewType {
        return JCInputViewType(rawValue: self.defects ?? "") ?? .Input_Text
    }
    
    /// 键盘类型 1 数字键盘
    var ventilation: Bool = false
    /// 可选值
    var identify: [JCAPPCommonChoiseModel]?
    /// 认证状态
    var protocols: Bool = false
    /// 服务返回的值
    var video: String?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["identify": JCAPPCommonChoiseModel.self]
    }
}
