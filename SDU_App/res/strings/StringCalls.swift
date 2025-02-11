//
//  StringCalls.swift
//  SDU App
//
//  Created by Nurkhat on 16.09.2024.
//

import Foundation

extension String {
    var lc: String {
        return NSLocalizedString(self, tableName: "courses_details", bundle: .main, value: "", comment: "")
    }
    
    var weeks: String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: "", comment: "")
    }
    
    var syswords: String {
        return NSLocalizedString(self, tableName: "sys_w", bundle: .main, value: "", comment: "")
    }
    
    
}
