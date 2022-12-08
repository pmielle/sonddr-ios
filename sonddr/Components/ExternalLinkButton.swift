//
//  ExternalLinkButton.swift
//  sonddr
//
//  Created by Paul Mielle on 08/12/2022.
//

import SwiftUI

struct ExternalLinkButton: View {

    // attributes
    // ------------------------------------------
    let externalLink: ExternalLink
    let icon: String
    
    // constructor
    // ------------------------------------------
    init(externalLink: ExternalLink) {
        self.externalLink = externalLink
        self.icon = ExternalLinkButton.chooseIcon(externalLink: externalLink)
    }
    
    
    // body
    // ------------------------------------------
    var body: some View {
        
        Image(self.icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: largeIconSize)

    }
    
    
    // subviews
    // ------------------------------------------
    // ...
    
    
    // methods
    // ------------------------------------------
    static func chooseIcon(externalLink: ExternalLink) -> String {
        switch externalLink {
        case .Instagram:
            return "InstagramLogo"
        case .Discord:
            return "DiscordLogo"
        case .GoogleDrive:
            return "GoogleDriveLogo"
        case .Slack:
            return "SlackLogo"
        case .Twitter:
            return "TwitterLogo"
        }
    }
}

struct ExternalLinkButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack { MyBackground()
                ExternalLinkButton(externalLink: .Instagram)
            }
        }
    }
}
