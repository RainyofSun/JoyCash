//
//  JCAPPLoanCityModel.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/22.
//

import UIKit

class JCAPPLoanCityModel: JCAPPBaseNetResponseModel, YYModel {
    
    var physicists: [JCAPPCityModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["physicists": JCAPPCityModel.self]
    }
    
    class func cacheCityMapJsonToDisk(_ jsonStr: String) {
//        if FileManager.default.fileExists(atPath: JCAPPPublic.shared.cityFilePath) {
//            JCAPPProductLog.debug("------- 本地已存储城市 -------")
//            return
//        }
        
        FileManager.default.createFile(atPath: JCAPPPublic.shared.cityFilePath, contents: jsonStr.data(using: String.Encoding.utf8))
    }
    
    class func readCityModelsFormDisk() -> [JCAPPCityModel] {
        if !FileManager.default.fileExists(atPath: JCAPPPublic.shared.cityFilePath) {
            return []
        }
        
        do {
            let _data: Data = try Data(contentsOf: NSURL(fileURLWithPath: JCAPPPublic.shared.cityFilePath) as URL)
            return JCAPPLoanCityModel.model(withJSON: _data)?.physicists ?? []
        } catch {
            
        }
        
        return []
    }
}

class JCAPPCityModel: JCAPPBaseNetResponseModel, YYModel {
    var mouse: String?
    /// 标题
    var foreign: String?
    /// 子级
    var physicists: [JCAPPCityModel]?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["physicists": JCAPPCityModel.self]
    }
}
