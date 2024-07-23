//
//  NFCMessages.swift
//  CashManager
//
//  Created by Serge Serci on 06/12/2022.
//

import Foundation

protocol NFCMessages {
    var initialMessage: String { get }
    var multipleTagsDetected: String { get }
    var unableToConnect: String { get }
    var tagNotNdefCompliant: String { get }
    var unableToQueryStatus: String { get }
    var failedToRead: String { get }
    var foundMessage: String { get }
    
}

class DefaultMessages: NFCMessages {
    var initialMessage = "Veuillez placer votre carte près du lecteur"
    var multipleTagsDetected = "cms_tag_multiple_tag_detected"
    var unableToConnect = "cms_tag_unable_to_connect"
    var tagNotNdefCompliant = "cms_tag_not_compliant"
    var unableToQueryStatus = "cms_tag_status_not_readable"
    var failedToRead = "Erreur de lecture de la carte"
    var foundMessage = "Carte lue avec succès"
}
