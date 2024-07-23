//
//  DropOnError.swift
//  CashManager
//
//  Created by Anthony Luong on 31/12/2022.
//

import SwiftUI
import Drops

func dropOnError(subtitle: String) -> Drop {
    return Drop(
        title: "Erreur",
        subtitle: subtitle,
        icon: UIImage(systemName: "exclamationmark.circle.fill"),
        position: .top,
        duration: 2.0
    )
}
