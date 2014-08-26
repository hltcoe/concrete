/*
 * Copyright 2012-2014 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.twitter
#@namespace scala edu.jhu.hlt.miser

//===========================================================================
// Twitter Metadata
//===========================================================================

/**
 * This section defines protobuf entries that can be used to store all
 * of the information that is provided by the Twitter API. This set
 * of definitions is meant to map one-to-one with the Twitter API data
 * structures; do not add any new fields that do not have
 * corresponding fields in the Twitter API. 
 *
 * https://dev.twitter.com/docs/platform-objects/
 */

/**
 * Information about a Twitter user.
 */

struct TwitterUser {
  1: optional i64 id
  3: optional string name
  4: optional string screenName
  5: optional string lang
  6: optional bool geoEnabled
  7: optional string createdAt
  8: optional i32 friendsCount
  9: optional i32 statusesCount
  10: optional bool verified
  11: optional i32 listedCount
  12: optional i32 favouritesCount // note british spelling; derived from Twitter schema
  13: optional i32 followersCount
  
  14: optional string location // may be empty
  15: optional string timeZone // may be empty
  16: optional string description // may be empty
  18: optional i32 utcOffset // may be empty
  19: optional string url // may be empty
}

/**
 * A twitter geocoordinate.
 */
struct TwitterLatLong {
  1: optional double latitude
  2: optional double longitude
}

struct BoundingBox {
  1: optional string type
  2: required list<TwitterLatLong> coordinateList
}

struct PlaceAttributes {
  1: optional string streetAddress
  2: optional string region
  3: optional string locality
}

struct UserMention {
  1: optional i32 startOffset
  2: optional i32 endOffset
  4: optional string screenName
  5: optional string name
  6: optional i64 id
}

struct URL {
  1: optional i32 startOffset
  2: optional i32 endOffset
  3: optional string expandedUrl
  4: optional string url
  5: optional string displayUrl
}

struct HashTag {
  1: optional string text
  2: optional i32 startOffset
  3: optional i32 endOffset
}

struct TwitterEntities {
  1: optional list<HashTag> hashtagList
  2: optional list<URL> urlList
  3: optional list<UserMention> userMentionList
}

struct TwitterPlace {
  1: optional string placeType
  2: optional string countryCode
  3: optional string country
  4: optional string fullName
  5: optional string name
  6: optional string id
  7: optional string url

  8: optional BoundingBox boundingBox
  9: optional PlaceAttributes attributes
}

struct TwitterCoordinates {
  1: optional string type
  2: optional TwitterLatLong coordinates
}

struct TweetInfo {
  1: optional i64 id
  3: optional string text
  
  // may be empty; use Message.startTime instead if you are processing a Message.
  4: optional string createdAt

  // may just contain TwitterUser.id and TwitterUser.screenName.
  5: optional TwitterUser user
  6: optional bool truncated
  7: optional TwitterEntities entities
  8: optional string source
  
  // may be empty
  9: optional TwitterCoordinates coordinates
  11: optional TwitterPlace place

  12: optional bool favorited
  13: optional bool retweeted
  
  // may be empty; in rare cases, might be a string
  14: optional i32 retweetCount

  // may be empty
  15: optional string inReplyToScreenName
  16: optional i64 inReplyToStatusId
  18: optional i64 inReplyToUserId
}
