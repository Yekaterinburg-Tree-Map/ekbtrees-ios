//
//  TreeEditorFormValidator.swift
//  EkbTreeMap
//
//  Created by s.petrov on 03.05.2021.
//

import Foundation


protocol TreeEditorFormFormatterProtocol {
    
    func formatInt(value: String?) throws -> Int?
    func formatDouble(value: String?) throws -> Double?
}


class TreeEditorFormFormatter: TreeEditorFormFormatterProtocol {
    
    enum FormattingError: Error {
        case failed
    }
    
    func formatInt(value: String?) throws -> Int? {
        guard let value = value, !value.isEmpty else {
            return nil
        }
        
        guard let result = Int(value) else {
            throw FormattingError.failed
        }
        
        return result
    }
    
    func formatDouble(value: String?) throws -> Double? {
        guard let value = value, !value.isEmpty else {
            return nil
        }
        
        guard let result = Double(value) else {
            throw FormattingError.failed
        }
        
        return result
    }
}
