//
//  JCAPPBuriedPointModel.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/20.
//

import UIKit

class JCAPPBuriedPointModel: JCAPPBaseNetResponseModel {
    /// 内存
    var suggestions: JCAPPMemoryInfoModel?
    /// 电量
    var accelerations: JCAPPBatteryElectricModel?
    /// 系统版本
    var decreases: JCAPPSystemInfoModel?
    /// 网络类型
    var remaining: JCAPPTimeAndCellularModel?
    /// Wi-Fi信息
    var detector: JCAPPWIFIModel?
    /// 设备状态
    var various: JCAPPPhoneModel?
}

class JCAPPMemoryInfoModel: JCAPPBaseNetResponseModel {
    /// 可用存储大小
    var early: String?
    /// 总存储大小
    var substantially: String?
    /// 可用内存大小
    var suitable: String?
    /// 总内存大小
    var array: String?
}

class JCAPPBatteryElectricModel: JCAPPBaseNetResponseModel {
    /// 剩余电量
    var fold: String?
    /// 是否在充电
    var four: String?
}

class JCAPPSystemInfoModel: JCAPPBaseNetResponseModel {
    /// 系统版本
    var number: String?
    /// 设备铭牌
    var acceleration: String?
    /// 原始型号
    var patterns: String?
}

class JCAPPPhoneModel: JCAPPBaseNetResponseModel {
    /// 是否位模拟器
    var combining: Int = .zero
    /// 是否越狱
    var filled: Int = .zero
}

class JCAPPTimeAndCellularModel: JCAPPBaseNetResponseModel {
    /// 时区ID
    var steps: String?
    /// 语言
    var concerning: String?
    /// IDFV
    var smash: String?
    /// 网络类型
    var set: String?
    /// IDFA
    var harmonics: String?
}

class JCAPPWIFIModel: JCAPPBaseNetResponseModel {
    var arrays: JCAPPWIFIInfoModel?
}

class JCAPPWIFIInfoModel: JCAPPBaseNetResponseModel {
    /// SSID Wi-Fi名字
    var foreign: String?
    /// BSSID
    var accomplished: String?
}
