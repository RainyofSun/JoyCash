//
//  JCCardTypeStruct.swift
//  FastVay
//
//  Created by Yu Chen  on 2024/12/14.
//

import UIKit

struct JCCardTypeStruct {
    var content: [String]?
    var isExpand: Bool = false
    var sectionTitle: String?
    
    static func conbineModels(data: [[String]]) -> [JCCardTypeStruct] {
        var dataModel: [JCCardTypeStruct] = []
        data.enumerated().forEach { (index: Int, item: [String]) in
            if index%2 == .zero {
                dataModel.append(JCCardTypeStruct(content: item, isExpand: index == .zero, sectionTitle:"Recommended lD Type"))
            } else {
                dataModel.append(JCCardTypeStruct(content: item, isExpand: false, sectionTitle:"Backup lD Type"))
            }
        }
        
        return dataModel
    }
}
