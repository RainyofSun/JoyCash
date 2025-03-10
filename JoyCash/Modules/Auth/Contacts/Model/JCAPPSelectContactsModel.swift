//
//  JCAPPSelectContactsModel.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/3/1.
//

import UIKit

class JCAPPSelectContactsModel: JCAPPBaseNetResponseModel {
    /// 联系人是否填写 空表示未填写
    var historically: String?
    /// 联系人名字
    var foreign: String?
    /// 联系人电话
    var interpretations: String?
    /// 一级标题
    var graphic: String?
    /// 二级关系标题
    var reproducibility: String?
    /// 预留文案
    var aims: String?
    /// 二级手机号码和联系人标题
    var mre: String?
    /// 预留字文案
    var elastography: String?
    /// 关系
    var identify: [JCAPPCommonChoiseModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["identify": JCAPPCommonChoiseModel.self]
    }
}

class JCAPPEmergencyContactsModel: JCAPPBaseNetResponseModel {
    /// 联系人姓名
    var foreign: String?
    /// 联系人关系
    var historically: String?
    /// 联系人电话
    var interpretations: String?
    /// 标记
    var personTag: Int = .zero
}

class JCAPPBuryContactsModel: JCAPPBaseNetResponseModel {
    /// 手机号
    var incorporated: String?
    /// 更新时间
    var fashion: String?
    /// 创建时间
    var foods: String?
    /// 生日
    var pacemakers: String?
    /// 邮箱
    var rather: String?
    /// 姓名
    var foreign: String?
    /// 备注
    var traditional: String?
}
