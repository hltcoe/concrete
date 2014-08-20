/*
 * Copyright 2012-2014 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.communication
#@namespace scala edu.jhu.hlt.miser

include "uuid.thrift"
include "language.thrift"
include "structure.thrift"
include "entities.thrift"
include "situations.thrift"
include "email.thrift"
include "twitter.thrift"
include "audio.thrift"
include "nitf.thrift"
include "metadata.thrift"

typedef uuid.UUID UUID
typedef metadata.AnnotationMetadata Metadata

/**
 * A struct that represents information about where a communication
 * originated from. This was created in order to represent a
 * notion of derived communications from systems like machine
 * translation.
 */
struct Derivation {
  /**
   * Pointer to derived parent's UUID.
   */
  1: required UUID parentUuid

  /**
   * AnnotationMetadata object. Useful to determine
   * what tool is responsible for producing this derived communication.
   */
  2: required Metadata metadata
}

/** 
 * A single communication instance, containing linguistic content
 * generated by a single speaker or author.  This type is used for
 * both inter-personal communications (such as phone calls or
 * conversations) and third-party communications (such as news
 * articles).
 *
 * Each communication instance is grounded by its original
 * (unannotated) contents, which should be stored in either the
 * "text" field (for text communications) or the "audio" field (for
 * audio communications).  If the communication is not available in
 * its original form, then these fields should store the
 * communication in the least-processed form available.
 */
struct Communication {
  /** 
   * Stable identifier for this communication, identifying both the
   * name of the source corpus and the document that it corresponds to
   * in that corpus. 
   */
  1: required string id

  /** 
   * Universally unique identifier for this communication instance.
   * This is generated randomly, and can *not* be mapped back to the
   * source corpus. It is used as a target for symbolic "pointers".
   */
  2: required UUID uuid

  /** 
   * An enumeration used to indicate what type of communication this
   * is. The optional fields named "<i>kind</i>Info" can be used to
   * store extra fields that are specific to the communication
   * type. 
   */
  3: required string type

  /** 
   * The full text contents of this communication in its original
   * form, or in the least-processed form available, if the original
   * is not available. 
   */
  4: optional string text

  /** 
   * The time when this communication started (in unix time UTC --
   * i.e., seconds since January 1, 1970).  
   */
  5: optional i64 startTime

  /** 
   * The time when this communication ended (in unix time UTC --
   * i.e., seconds since January 1, 1970). 
   */
  6: optional i64 endTime

  /**
   * Text that can be lightly processed - for example, taking an
   * HTML document and removing tags so that NLP tools can better
   * run over it. 
   */
  7: optional string processedContent
  
  /** 
   * Theories about the languages that are present in this
   * communication. 
   */
  10: optional list<language.LanguageIdentification> lidList

  
  /**
   * Theories about the block structure of this communication.
   */
  11: optional list<structure.SectionSegmentation> sectionSegmentationList

  /** 
   * Theories about which spans of text are used to mention entities
   * in this communication. 
   */
  12: optional list<entities.EntityMentionSet> entityMentionSetList

  /** 
   * Theories about what entities are discussed in this
   * communication, with pointers to individual mentions. 
   */
  13: optional list<entities.EntitySet> entitySetList

  /** 
   * Theories about what situations are explicitly mentioned in this
   * communication. 
   */
  14: optional list<situations.SituationMentionSet> situationMentionSetList

  /** 
   * Theories about what situations are asserted in this
   * communication. 
   */
  15: optional list<situations.SituationSet> situationSetList
  
  /** 
   * The full audio contents of this communication in its original
   * form, or in the least-processed form available, if the original
   * is not available. 
   */
  20: optional audio.Sound sound
  
  /** 
   * Extra information for communications where kind==TWEET:
   * Information about this tweet that is provided by the Twitter
   * API.  For information about the Twitter API, see:
   * <https://dev.twitter.com/docs/platform-objects> 
   */
  21: optional twitter.TweetInfo tweetInfo

  /**
   * Extra information for communications where kind==EMAIL
   */
  22: optional email.EmailCommunicationInfo emailInfo

  /**
   * Extra information that may come from the NITF
   * (News Industry Text Format) schema. See 'nitf.thrift'.
   */

  23: optional nitf.NITFInfo nitfInfo
  
  /**
   * A catch-all store of keys and values. Use sparingly!
   */
  30: optional map<string, string> keyValueMap

  
  /**
   * Is this a derived communication (e.g., via machine translation)?
   *
   * Required to encourage developers to label appropriately.
   */ 
  40: required bool isDerived

  /**
   * Information about how this communication originated, if
   * it is derived. 
   *
   * Validation will require this field be set if isDerived is set
   * to true. 
   */ 
  41: optional Derivation derivation
}
