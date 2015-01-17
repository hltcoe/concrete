/*
 * Copyright 2012-2015 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.linking
namespace cpp concrete
#@namespace scala edu.jhu.hlt.miser

include "uuid.thrift"
include "language.thrift"
include "structure.thrift"
include "entities.thrift"
include "situations.thrift"
include "audio.thrift"
include "metadata.thrift"

/**
 * A structure that represents entity linking assertions. 
 */
struct Linking {
  /**
   * The UUID of the EntitySet, EntityMentionSet, SituationSet, or SituationMentionSet
   * that this Linking object is associated with.
   */
  required uuid.UUID setId

  /**
   * Metadata related to this Linking object.
   */
  required metadata.AnnotationMetadata metadata

  /**
   * A list of Link objects that this Linking object contains.
   */
  required List<Link> linkList
}

/**
 * A structure that represents the origin of an entity linking assertion.
 */
struct Link {
  /**
   * The "root" of this Link; points to a EntityMention UUID, Entity UUID, etc. 
   */
  required uuid.UUID sourceId

  /**
   * A list of LinkTarget objects that this Link contains.
   */
  required list<LinkTarget> linkTargetList
}

/**
 * A structure that represents the target of an entity linking assertion. 
 */
struct LinkTarget {

  /**
   * Confidence of this LinkTarget object.
   */
  optional double confidence

  /**
   * a UUID that represents the target of this LinkTarget. 
   *
   * If this LinkTarget is represented in Concrete (for example, an Entity),
   * then the Linking object's setId should capture the EntitySet
   * which contains this Entity's UUID.
   */
  optional uuid.UUID targetId

  // or a string ID and an optional reference to the collection

  /**
   * A database ID that represents the target of this linking. 
   *
   * This should be used if the target of the linking is not associated
   * with an EntitySet in Concrete, and therefore cannot be linked by
   * a UUID internal to concrete. 
   *
   * Additionally, the other optional field 'dbName' should be populated.
   */
  optional String dbId

  /**
   * The name of the database that represents the target of this linking.
   *
   * Together with the 'dbId', this can form a pointer to a target
   * that is not represented inside concrete.
   *
   * Should be populated alongside 'dbId'.
   */
  optional String dbName // e.g., "Freebase"
}