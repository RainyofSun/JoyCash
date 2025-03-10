//
//  JCAPPCommonValueModel.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/23.
//

import UIKit

class JCAPPCommonValueModel: JCAPPBaseNetResponseModel {
    /// 标题
    var graphic: String?
    /// 值
    var extensive: String?
    /////////////// 产品详情 ////////////////
    /// 产品详情协议跳转地址
    var done: String?
    /// 产品详情使用 - 值
    var fatal: String?
}

class JCAPPCommonChoiseModel: JCAPPBaseNetResponseModel {
    /// 标题
    var foreign: String?
    /// 值
    var late: String?
}
