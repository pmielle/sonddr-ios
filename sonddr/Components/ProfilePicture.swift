//
//  ProfilePicture.swift
//  sonddr
//
//  Created by Paul Mielle on 15/11/2022.
//

import SwiftUI

struct ProfilePicture: View {
    let user: User
    let large: Bool
    let size: CGFloat
    
    init(user: User, large: Bool = false) {
        self.user = user
        self.large = large
        self.size = large ? largeProfilePictureSize : profilePictureSize
    }
    
    var body: some View {
        Rectangle()
            .frame(width: self.size, height: self.size)
            .overlay {
                Image(self.user.profilePicture)
                    .resizable()
            }
            .cornerRadius(99)
    }
}

struct ProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicture(user: dummyUser())
        ProfilePicture(user: dummyUser(), large: true)
            .previewDisplayName("Large")
    }
}
