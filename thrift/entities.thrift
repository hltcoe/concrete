/*
 * Copyright 2012-2014 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.entities
namespace cpp concrete
#@namespace scala edu.jhu.hlt.miser

include "structure.thrift"
include "metadata.thrift"
include "uuid.thrift"
include "linking.thrift"

/** 
 * A span of text with a specific referent, such as a person,
 * organization, or time. Things that can be referred to by a mention
 * are called "entities."
 *
 * It is left up to individual EntityMention taggers to decide which
 * referent types and phrase types to identify. For example, some
 * EntityMention taggers may only identify proper nouns, or may only
 * identify EntityMentions that refer to people.
 *
 * Each EntityMention consists of a sequence of tokens. This sequence
 * is usually annotated with information about the referent type
 * (e.g., is it a person, or a location, or an organization, etc) as
 * well as the phrase type (is it a name, pronoun, common noun, etc.).
 *
 * EntityMentions typically consist of a single noun phrase; however,
 * other phrase types may also be marked as mentions. For
 * example, in the phrase "French hotel," the adjective "French" might
 * be marked as a mention for France.
 */

/**
 * A single referent (or "entity") that is referred to at least once
 * in a given communication, along with pointers to all of the
 * references to that referent. The referent's type (e.g., is it a
 * person, or a location, or an organization, etc) is also recorded.
 *
 * Because each Entity contains pointers to all references to a
 * referent with a given communication, an Entity can be
 * thought of as a coreference set.
 */
struct Entity {
  /**
   * Unique identifier for this entity.
   */
  1: required uuid.UUID uuid
  
  /**
   * An list of pointers to all of the mentions of this Entity's
   * referent.  (type=EntityMention) 
   */
  2: required list<uuid.UUID> mentionIdList

  /**
   * The basic type of this entity's referent. 
   */
  3: optional string type

  /**  
   * Confidence score for this individual entity.  You can also set a
   * confidence score for an entire EntitySet using the EntitySet's
   * metadata. 
   */
  4: optional double confidence

  /**
   * A string containing a representative, canonical, or "best" name
   * for this entity's referent.  This string may match one of the
   * mentions' text strings, but it is not required to. 
   */
  5: optional string canonicalName
}

/** 
 * A theory about the set of entities that are present in a
 * message. See also: Entity.
 */
struct EntitySet {
  /** 
   * Unique identifier for this set. 
   */
  1: required uuid.UUID uuid

  /**
   * Information about where this set came from.
   */
  2: required metadata.AnnotationMetadata metadata

  /**
   * List of entities in this set.
   */
  3: required list<Entity> entityList

  /**
   * Entity linking annotations associated with this EntitySet.
   */
  4: optional list<linking.Linking> linkingList

  /**
   * An optional UUID pointer to an EntityMentionSet.
   *
   * If this field is present, consumers can assume that all
   * Entity objects in this EntitySet have EntityMentions that are included
   * in the named EntityMentionSet.
   */
  5: optional uuid.UUID mentionSetId

}

//===========================================================================
// Entity Mentions
//===========================================================================

/** 
 * A span of text with a specific referent, such as a person,
 * organization, or time. Things that can be referred to by a mention
 * are called "entities."
 *
 * It is left up to individual EntityMention taggers to decide which
 * referent types and phrase types to identify. For example, some
 * EntityMention taggers may only identify proper nouns, or may only
 * identify EntityMentions that refer to people.
 *
 * Each EntityMention consists of a sequence of tokens. This sequence
 * is usually annotated with information about the referent type
 * (e.g., is it a person, or a location, or an organization, etc) as
 * well as the phrase type (is it a name, pronoun, common noun, etc.).
 *
 * EntityMentions typically consist of a single noun phrase; however,
 * other phrase types may also be marked as mentions. For
 * example, in the phrase "French hotel," the adjective "French" might
 * be marked as a mention for France.
 */
struct EntityMention {
  /*
   * A unique idenifier for this entity mention.
   */
  1: required uuid.UUID uuid

  /**
   * Pointer to sequence of tokens.
   */
  2: required structure.TokenRefSequence tokens
  
  /**
   * The type of referent that is referred to by this mention. 
   */
  3: optional string entityType
  
  /**
   * The phrase type of the tokens that constitute this mention. 
   */
  4: optional string phraseType

  /**
   * A confidence score for this individual mention.  You can also
   * set a confidence score for an entire EntityMentionSet using the
   * EntityMentionSet's metadata. 
   */
  5: optional double confidence

  /**
   * The text content of this entity mention.  This field is
   * typically redundant with the string formed by cross-referencing 
   * the 'tokens.tokenIndexList' field with this mention's 
   * tokenization. This field may not be generated by all analytics.
   */
  6: optional string text

  /**
   * A list of pointers to the "child" EntityMentions of this
   * EntityMention.
   */
  7: optional list<uuid.UUID> childMentionIdList

}


/**
 * A theory about the set of entity mentions that are present in a
 * message. See also: EntityMention
 *
 * This type does not represent a coreference relationship, which is handled by Entity.
 * This type is meant to represent the output of a entity-mention-identifier,
 * which is often a part of an in-doc coreference system.
 */
struct EntityMentionSet {
  /** 
   * Unique identifier for this set. 
   */
  1: required uuid.UUID uuid
  
  /**
   * Information about where this set came from. 
   */
  2: required metadata.AnnotationMetadata metadata

  /**
   * List of mentions in this set. 
   */
  3: required list<EntityMention> mentionList

  /**
   * Entity linking annotations associated with this EntityMentionSet.
   */
  4: optional list<linking.Linking> linkingList
}
