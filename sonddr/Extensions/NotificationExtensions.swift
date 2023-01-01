//
//  NotificationExtensions.swift
//  sonddr
//
//  Created by Paul Mielle on 21/11/2022.
//

import Foundation

extension Notification.Name {
    static let ideasBottomBarIconTap = Notification.Name("ideasBottomBarIconTap")
    static let searchBottomBarIconTap = Notification.Name("searchBottomBarIconTap")
    static let notificationsBottomBarIconTap = Notification.Name("notificationsBottomBarIconTap")
    static let messagesBottomBarIconTap = Notification.Name("messagesBottomBarIconTap")
    static let addFabTap = Notification.Name("addFabTap")
    static let sendFabTap = Notification.Name("sendFabTap")
    static let commentFabTap = Notification.Name("commentFabTap")
    static let newDiscussionFabTap = Notification.Name("newDiscussionFabTap")
    static let goToDiscussionFabTap = Notification.Name("goToDiscussionFabTap")
    static let goToDiscussion = Notification.Name("goToDiscussion")
}
