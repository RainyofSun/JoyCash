//
//  JCAPPBuriedPointReport.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/20.
//

import UIKit
import AdSupport

class JCAPPBuriedPointReport: NSObject {
    /// 位置上报
    class func JCAPPLocationBuryReport() {
        
        var params: [String: String] = [:]
        // 国家代码
        if let _contry_code = JCAPPDeviceAuthorizationTool.authorization().placeMark.isoCountryCode {
            params["grappa"] = _contry_code
        }
        
        // 国家
        if let _country = JCAPPDeviceAuthorizationTool.authorization().placeMark.country {
            params["acquisitions"] = _country
        }
        
        // 省
        if let _locatity = JCAPPDeviceAuthorizationTool.authorization().placeMark.locality {
            params["common"] = _locatity
        }
        
        // 直辖市
        if let _city = JCAPPDeviceAuthorizationTool.authorization().placeMark.administrativeArea {
            params["sense"] = _city
        }
        
        // 街道
        if let _street = JCAPPDeviceAuthorizationTool.authorization().placeMark.thoroughfare {
            params["partially"] = _street
        }
        
        // 区/县
        if let _area = JCAPPDeviceAuthorizationTool.authorization().placeMark.subLocality {
            params["encoding"] = _area
        }
        
        // 经纬度
        params["autocalibrating"] = "\(JCAPPDeviceAuthorizationTool.authorization().location.coordinate.latitude)"
        params["generalized"] = "\(JCAPPDeviceAuthorizationTool.authorization().location.coordinate.longitude)"
        
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/mansfield", requestParams: params)) { _, _ in
            
        }
    }
    
    /// IDFA&IDFV 上报
    class func JCAPPIDFAAndIDFVBuryReport() {
        let idfaStr: String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let idfvStr: String = UIDevice.current.readIDFVFormKeyChain()
        
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/physicists", requestParams: ["smash": idfvStr, "harmonics": idfaStr])) { _, _ in
            
        }
    }
    
    /// 设备信息上报
    class func JCAPPDeviceInfoBuryReport() {
        // 内存信息
        let memoryModel: JCAPPMemoryInfoModel = JCAPPMemoryInfoModel()
        let diskCacheDict = UIDevice.getAppDiskSize()
        memoryModel.early = diskCacheDict["availableCapacity"] as? String
        memoryModel.substantially = diskCacheDict["totalCapacity"] as? String
        memoryModel.array = "\(UIDevice.current.memoryTotal)"
        memoryModel.suitable = UIDevice.getFreeMemory()
        
        JCAPPProductLog.debug(" ----- 埋点内存 -------\n 总容量 = \(memoryModel.substantially ?? "") \n 可用容量 = \(memoryModel.early ?? "") \n 总内存 = \(memoryModel.array ?? "") \n 使用内存 = \(memoryModel.suitable ?? "") \n")
        
        // 电量
        let electricArray = UIDevice.current.appBattery()
        let electricModel: JCAPPBatteryElectricModel = JCAPPBatteryElectricModel()
        electricModel.fold = electricArray.first
        electricModel.four = electricArray.last
        
        JCAPPProductLog.debug(" ----- 埋点电量 -------\n 电池电量 = \(electricModel.fold ?? "") \n 电池状态 = \(electricModel.four ?? "") \n")
        
        // 系统版本
        let systemModel: JCAPPSystemInfoModel = JCAPPSystemInfoModel()
        systemModel.number = UIDevice.current.systemVersion
        systemModel.acceleration = UIDevice.current.machineModelName
        systemModel.patterns = UIDevice.current.machineModel
        
        JCAPPProductLog.debug(" ----- 埋点版本 -------\n 系统版本 = \(systemModel.number ?? "") \n 设备名称 = \(systemModel.acceleration ?? "") \n 设备原始版本 = \(systemModel.patterns ?? "") \n")
        
        // 时区/网络
        let timeModel: JCAPPTimeAndCellularModel = JCAPPTimeAndCellularModel()
        timeModel.steps = TimeZone.current.identifier
        timeModel.concerning = Locale.current.languageCode
        timeModel.smash = UIDevice.current.readIDFVFormKeyChain()
        timeModel.set = UIDevice.current.getNetconnType()
        if JCAPPDeviceAuthorizationTool.authorization().attTrackingStatus() == .authorized {
            timeModel.harmonics = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        
        JCAPPProductLog.debug(" ----- 埋点版本 -------\n 系统时区 = \(timeModel.steps ?? "") \n 设备语言 = \(timeModel.concerning ?? "") \n 设备IDFV = \(timeModel.smash ?? "") \n 设备网络类型 = \(timeModel.set ?? "") \n 设备IDFA = \(timeModel.harmonics ?? "") \n")
        
        // wifi
        let wifiInfoModel: JCAPPWIFIInfoModel = JCAPPWIFIInfoModel()
        let wifiArray = UIDevice.current.getWiFiInfo()
        wifiInfoModel.foreign = wifiArray.first
        wifiInfoModel.accomplished = wifiArray.last
        
        JCAPPProductLog.debug(" ----- 埋点设备WIFI -------\n SSID = \(wifiArray.first ?? "") \n BSSID = \(wifiArray.last ?? "") \n")
        
        let wifiModel: JCAPPWIFIModel = JCAPPWIFIModel()
        wifiModel.arrays = wifiInfoModel
        
        // 设备信息
        let phoneModel: JCAPPPhoneModel = JCAPPPhoneModel()
        phoneModel.combining = NSNumber(booleanLiteral: UIDevice.current.isSimulator).intValue
        phoneModel.filled = NSNumber(booleanLiteral: UIDevice.current.isJailbroken).intValue
        
        let deviceModel: JCAPPBuriedPointModel = JCAPPBuriedPointModel()
        deviceModel.suggestions = memoryModel
        deviceModel.accelerations = electricModel
        deviceModel.decreases = systemModel
        deviceModel.remaining = timeModel
        deviceModel.detector = wifiModel
        deviceModel.various = phoneModel
        
        guard let _jsonStr = deviceModel.modelToJSONString() else {
            return
        }
        
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/peter", requestParams: ["awarded": _jsonStr])) { _, _ in
            
        }
    }
    
    /// 风控信息上报
    class func JCAPPRiskControlInfoBuryReport(riskType: JCRiskControlPointsType, beginTime: String? = nil, endTime: String? = nil, orderNum: String? = nil) {
        var params: [String: String] = [:]
        if let _t1 = beginTime {
            params["went"] = _t1
        }
        
        if let _t2 = endTime {
            params["accelerate"] = _t2
        }
        
        if let _order_num = orderNum {
            params["detectors"] = _order_num
        }
        
        params["widespread"] = "\(riskType.rawValue)"
        
        params["unremarked"] = UIDevice.current.readIDFVFormKeyChain()
        params["autocalibrating"] = "\(JCAPPDeviceAuthorizationTool.authorization().location.coordinate.latitude)"
        params["generalized"] = "\(JCAPPDeviceAuthorizationTool.authorization().location.coordinate.longitude)"
        params["saw"] = "2"
        
        if JCAPPDeviceAuthorizationTool.authorization().attTrackingStatus() == .authorized {
            params["largely"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        JCAPPProductLog.debug("-------- 埋点 风控埋点 = \(riskType) -------")
        JCAPPNetRequestManager.afnReqeustType(NetworkRequestConfig.defaultRequestConfig("said/like", requestParams: params)) { _, _ in
            
        }
    }
}
