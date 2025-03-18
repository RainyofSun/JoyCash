//
//  JCAPPBeginnerModel.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/20.
//

import UIKit

class JCAPPBeginnerModel: JCAPPBaseNetResponseModel {
    /// 引导
    var awarded: JCBeginnerGuideModel?
    /// 隐私协议
    var computational: String?
    /// Face
    var practical: JCBeginnerFacebookModel?
    /// 是否要弹窗
    var power: Int = -1
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["practical": JCAPPBaseNetResponseModel.self, "awarded": JCBeginnerGuideModel.self]
    }
}

class JCBeginnerGuideModel: JCAPPBaseNetResponseModel, YYModel {
    /// 1=印度（审核面）   2=墨西哥(用户面)
    var chip: Int = .zero
    var circuit: JCBeginnerServiceModel?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["circuit": JCBeginnerServiceModel.self]
    }
}

class JCBeginnerServiceModel: JCAPPBaseNetResponseModel {
    /// 地址1
    var integrated: String?
    /// 地址2
    var transistors: String?
}

class JCBeginnerFacebookModel: JCAPPBaseNetResponseModel {
    /// CFBundleURLScheme
    var crucial: String?
    /// FacebookAppID
    var semiconductor: String?
    /// FacebookDisplayName
    var advances: String?
    /// FacebookClientToke
    var built: String?
}
