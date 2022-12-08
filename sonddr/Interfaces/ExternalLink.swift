//
//  ExternalLink.swift
//  sonddr
//
//  Created by Paul Mielle on 08/12/2022.
//

import Foundation

enum ExternalLink {
    case Instagram
    case Twitter
    case Slack
    case Discord
    case GoogleDrive
}

func dummyExternalLink() -> ExternalLink {
    return .Instagram
}
