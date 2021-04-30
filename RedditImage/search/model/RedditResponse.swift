//
//  RedditResponse.swift
//  RedditImage
//
//  Created by Manuel Cipolotti Beta on 29/04/2021.
//

import Foundation


import Foundation

// MARK: - Welcome
struct RedditResponse: Codable {
    let kind: String?
    let data: WelcomeData?
}

// MARK: - WelcomeData
struct WelcomeData: Codable {
    let modhash: String?
    let dist: Int?
    let children: [Child]?
//    let after, before: NSNull
}

// MARK: - Child
struct Child: Codable {
    let kind: String?
    let data: ChildData?
}

// MARK: - ChildData
struct ChildData: Codable {
//    let approvedAtUTC: NSNull
    let subreddit, selftext, authorFullname: String?
    let saved: Bool?
//    let modReasonTitle: NSNull
    let gilded: Int?
    let clicked, isGallery: Bool?
    let title: String?
//    let linkFlairRichtext: [Any?]
    let subredditNamePrefixed: String?
    let hidden: Bool?
    let pwls: Int?
//    let linkFlairCSSClass: NSNull
    let downs, thumbnailHeight: Int?
//    let topAwardedType: NSNull
    let hideScore: Bool?
    let mediaMetadata: [String: MediaMetadatum]?
    let name: String?
    let quarantine: Bool?
    let linkFlairTextColor: String?
    let upvoteRatio: Int?
//    let authorFlairBackgroundColor: NSNull
    let subredditType: String?
    let ups, totalAwardsReceived: Int?
    let mediaEmbed: Gildings?
    let thumbnailWidth: Int?
//    let authorFlairTemplateID: NSNull
    let isOriginalContent: Bool?
//    let userReports: [Any?]
//    let secureMedia: NSNull
    let isRedditMediaDomain, isMeta: Bool?
//    let category: NSNull
    let secureMediaEmbed: Gildings?
    let galleryData: GalleryData?
//    let linkFlairText: NSNull
    let canModPost: Bool?
    let score: Int?
//    let approvedBy: NSNull
    let authorPremium: Bool?
    let thumbnail: String?
//    let edited: Bool?
//    let authorFlairCSSClass: NSNull
//    let authorFlairRichtext: [Any?]
    let gildings: Gildings?
//    let contentCategories: NSNull
    let isSelf: Bool?
//    let modNote: NSNull
    let created: Int?
    let linkFlairType: String?
    let wls: Int?
//    let removedByCategory, bannedBy: NSNull
    let authorFlairType, domain: String?
    let allowLiveComments: Bool?
//    let selftextHTML, likes, suggestedSort, bannedAtUTC: NSNull
    let urlOverriddenByDest: String?
//    let viewCount: NSNull
    let archived, noFollow, isCrosspostable, pinned: Bool?
    let over18: Bool?
//    let allAwardings, awarders: [Any?]
    let mediaOnly, canGild, spoiler, locked: Bool?
//    let authorFlairText: NSNull
//    let treatmentTags: [Any?]
    let visited: Bool?
//    let removedBy, numReports, distinguished: NSNull
    let subredditID: String?
//    let modReasonBy, removalReason: NSNull
    let linkFlairBackgroundColor, id: String?
    let isRobotIndexable: Bool?
//    let reportReasons: NSNull
    let author: String?
//    let discussionType: NSNull
    let numComments: Int?
    let sendReplies: Bool?
    let whitelistStatus: String?
    let contestMode: Bool?
//    let modReports: [Any?]
    let authorPatreonFlair: Bool?
//    let authorFlairTextColor: NSNull
    let permalink, parentWhitelistStatus: String?
    let stickied: Bool?
    let url: String?
    let subredditSubscribers, createdUTC, numCrossposts: Int?
//    let media: NSNull
    let isVideo: Bool?
}

// MARK: - GalleryData
struct GalleryData: Codable {
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let caption, mediaID: String?
    let id: Int?
}

// MARK: - Gildings
struct Gildings: Codable {
}

// MARK: - MediaMetadatum
struct MediaMetadatum: Codable {
    let status, e, m: String?
    let p: [S]?
    let s: S?
    let id: String?
}

// MARK: - S
struct S: Codable {
    let y, x: Int?
    let u: String?
}
