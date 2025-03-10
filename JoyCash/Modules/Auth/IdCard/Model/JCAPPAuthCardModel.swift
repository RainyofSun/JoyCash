//
//  JCAPPAuthCardModel.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit

class JCAPPAuthCardModel: JCAPPBaseNetResponseModel, YYModel {
    /// 卡片认证状态
    var third: JCAPPCardAuthStateModel?
    /// 活体认证状态
    var least: JCAPPCardAuthStateModel?
    /// 照片上传类型
    var appears: Int = 1
    /// 首选证件类型
    var pregnancy: [String]?
    /// 备选证件类型
    var eyes: [String]?

    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["third": JCAPPCardAuthStateModel.self, "least": JCAPPCardAuthStateModel.self]
    }
}

class JCAPPCardAuthStateModel: JCAPPBaseNetResponseModel {
    /// 是否完成认证
    var protocols: Bool = false
    /// 图片地址
    var zeugmatography: String?
    /// 证件类型
    var second: String?
}
