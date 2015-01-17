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
include "metadata.thrift"

/**
 * A structure that represents the target of an entity linking annotation.
 */
struct LinkTarget {

  /**
   * Confidence of this LinkTarget object.
   */
  1: optional double confidence

  /**
   * A UUID that represents the target of this LinkTarget. This
   * UUID should exist in the Entity/Situation(Mention)Set that the
   * Linking object is contained in.
   */
  2: optional uuid.UUID targetId

  /**
   * A database ID that represents the target of this linking. 
   *
   * This should be used if the target of the linking is not associated
   * with an Entity|Situation(Mention)Set in Concrete, and therefore cannot be linked by
   * a UUID internal to concrete. 
   *
   * If present, other optional field 'dbName' should also be populated.
   */
  3: optional string dbId

  /**
   * The name of the database that represents the target of this linking.
   *
   * Together with the 'dbId', this can form a pointer to a target
   * that is not represented inside concrete.
   *
   * Should be populated alongside 'dbId'.
   */
  4: optional string dbName // e.g., "Freebase"
}

/**
 * A structure that represents the origin of an entity linking annotation.
 */
struct Link {
  /**
   * The "root" of this Link; points to a EntityMention UUID, Entity UUID, etc. 
   */
  1: required uuid.UUID sourceId

  /**
   * A list of LinkTarget objects that this Link contains.
   */
  2: required list<LinkTarget> linkTargetList
}

/**
 * A structure that represents entity linking annotations.
 */
struct Linking {
  /**
   * Metadata related to this Linking object.
   */
  1: required metadata.AnnotationMetadata metadata

  /**
   * A list of Link objects that this Linking object contains.
   */
  2: required list<Link> linkList
}
