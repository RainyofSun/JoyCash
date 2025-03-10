//
//  JCAPPAuthCardRecognitionModel.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/24.
//

import UIKit

class JCAPPAuthCardRecognitionModel: JCAPPBaseNetResponseModel, YYModel {

    /// 姓名
    var foreign: String?
    /// id_numer
    var metallic: String?
    /// 性别
    var shrapnel: String?
    /// 生日
    var pacemakers: String?
    /// 图片地址
    var zeugmatography: String?
    /// item
    var occur: [JCAPPRecognitionModel]?
    /// 弹窗顶部文案
    var failed: String?
    /// 顶部文案
    var injuries: String?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["occur": JCAPPRecognitionModel.self]
    }
}

class JCAPPRecognitionModel: JCAPPBaseNetResponseModel {
    /// 顶部文案
    var injuries: String?
    /// 内容
    var safe: String?
    /// 保存时的key
    var prize: String?
}
