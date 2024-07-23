//
//  DropOnSuccess.swift
//  CashManager
//
//  Created by Anthony Luong on 31/12/2022.
//

import SwiftUI
import Drops

func dropOnSuccess(subtitle: String) -> Drop {
    return Drop(
        title: "Succès",
        subtitle: subtitle,
        icon: UIImage(systemName: "checkmark.circle.fill"),
        position: .top,
        duration: 2.0
    )
}
