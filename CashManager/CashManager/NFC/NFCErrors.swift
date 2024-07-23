//
//  NFCErrors.swift
//  CashManager
//
//  Created by Serge Serci on 06/12/2022.
//


import Foundation

enum NFCErrors: LocalizedError {
    case scanningNotSupported
    case sessionInvalidated
    case wrongMessages
}
