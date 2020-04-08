//
//  DecryptUtil.swift
//  LiveScore v3
//
//  Created by Rosta on 18/04/16.
//  Copyright © 2016 LiveScore. All rights reserved.
//

import Foundation

extension Int {
    func conversionToCUnsignedChar() -> CUnsignedChar { return CUnsignedChar(self) }
}

open class DecryptUtil {
    
    open func decrypt(_ receivedData: Data?) -> Data? {
//        let apiSupportEncription = AppContext.shared.appState.environmentConfig?.apiSupportEncription ?? true
//        if !apiSupportEncription { //For testing purposes, some test servers don't support encryption
//            return receivedData
//        }
        
        if let data = receivedData {
            let bytes = [UInt8](data)
            
            if bytes.count >= 33 && bytes[12] == 58 && bytes[13] == 32 {
                let key = cryptKeyFromData(bytes: bytes, atIndex:14)
                return decryptData(bytes: bytes, i:33, key: key, version:1)
            }
            else if bytes.count >= 34 && bytes[12] == 58 && bytes[13] == 58 && bytes[14] == 32 {
                let key = cryptKeyFromData(bytes: bytes, atIndex:15)
                return decryptData(bytes: bytes, i:34, key: key, version:2)
            }
            else if bytes.count >= 35 && bytes[12] == 58 && bytes[13] == 58 && bytes[14] == 58 {
                let key = cryptKeyFromData(bytes: bytes, atIndex:16)
                return decryptData(bytes: bytes, i:35, key: key, version:3)
            }
        }
        
        return nil
    }
    
    private func cryptKeyFromData(bytes: [UInt8], atIndex: Int) -> UInt8 {
        var result: UInt8 = 27
        
        if bytes.count > atIndex + 18 {
            let z: UInt8 = 48 // == '0'
            
            //time
            let sec10 = bytes[atIndex + 17] - z
            let sec1 = bytes[atIndex + 18] - z
            let hour10 = bytes[atIndex + 11] - z
            
            result = getArrVal(array: bytes, i:atIndex) +
                getArrVal(array: bytes, i:atIndex + 1) +
                getArrVal(array: bytes, i:atIndex + 2) +
                getArrVal(array: bytes, i:atIndex + 3) +
                getArrVal(array: bytes, i:atIndex + 5) +
                getArrVal(array: bytes, i:atIndex + 6) +
                getArrVal(array: bytes, i:atIndex + 8) +
                getArrVal(array: bytes, i:atIndex + 9) +
                hour10 +
                getArrVal(array: bytes, i:atIndex + 12) +
                getArrVal(array: bytes, i:atIndex + 14) +
                getArrVal(array: bytes, i:atIndex + 15) +
                sec10 +
                sec1
            
            if sec1 >= sec10 {
                result += sec1 - sec10
            }
            else {
                result += (hour10 + 1) * 3
            }
        }
        
        return result
    }
    
    private func getArrVal(array: [UInt8], i: Int) -> UInt8 {
        let z: UInt8 = 48 // == '0'
        return array[i] - z
    }
    
    private func checkChar1(char1: UInt8, char2: UInt8, char3: UInt8, codes:[UInt8]) -> Bool {
        let len = codes[0]
        let code1 = codes[1]
        let code2 = codes[2]
        let code3 = codes[3]
        
        switch len {
        case 1:
            return char3 == code1
        case 2:
            return char2 == code1 && char3 == code2
        case 3:
            return char1 == code1 && char2 == code2 && char3 == code3
        default:
            break
        }
        
        return false
    }
    
    private func decryptData(bytes: [UInt8], i: Int, key: UInt8, version: Int) -> Data {
        var code10 = [UInt8]()
        var code12 = [UInt8]()
        var code32 = [UInt8]()
        
        if version == 1 {
            code10 = [1, 33, 0, 0]
            code12 = [1, 36, 0, 0]
            code32 = [1, 37, 0, 0]
        }
        else if version == 2 {
            code10 = [1, 171, 0, 0]
            code12 = [1, 169, 0, 0]
            code32 = [1, 187, 0, 0]
        }
        else if version == 3 {
            code10 = [3, 33, 36, 24]
            code12 = [3, 35, 37, 38]
            code32 = [3, 37, 35, 36]
        }
        
        let decData = NSMutableData()
        let length = bytes.count
        
        //for var k = length - 1, j = 0; k >= i; k-=1, j+=1
        var j = 0
        var k = length - 1
        while k >= i
        {
            let ch = bytes[k]
            let idx = (length - k) % 10
            var n: UInt8
            
            if ch >= 40 && ch <= 126 {
                let x = Int(ch) - Int(key) - idx
                n = (x < 40) ? UInt8(x + 87) : x.conversionToCUnsignedChar()
            }
            else
            {
                var ch1: UInt8 = 0
                var ch2: UInt8 = 0
                if k > i { ch2 = bytes[k - 1] }
                if k > i + 1 { ch1 = bytes[k - 2] }
                
                if checkChar1(char1: ch1, char2:ch2, char3:ch, codes:code10) {
                    let l = code10[0]
                    n = 10
                    k -= Int(l) - 1
                }
                else if checkChar1(char1: ch1, char2:ch2, char3:ch, codes:code12) {
                    let l = code12[0]
                    n = 13
                    k -= Int(l) - 1
                }
                else if checkChar1(char1: ch1, char2:ch2, char3:ch, codes:code32) {
                    let l = code32[0]
                    n = 32
                    k -= Int(l) - 1
                }
                else {
                    n = ch
                }
            }//else
            
            //put data
            decData.append(&n, length: MemoryLayout<UInt8>.size)
            
            k -= 1
            j += 1
        }//end loop
        
        return decData as Data
    }
}
