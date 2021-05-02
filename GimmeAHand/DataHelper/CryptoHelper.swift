//
//  CryptoHelper.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 5/2/21.
//

import UIKit
import CryptoSwift

class CryptoHelper: NSObject {
    
    static func encrypt(_ str: String) -> String {
        let password: Array<UInt8> = Array(str.utf8)
        let salt: Array<UInt8> = Array("KUCN*6td".utf8)
        let key = try! HKDF(password: password, salt: salt, variant: .sha256).calculate()
        return key.toHexString()
    }

}
