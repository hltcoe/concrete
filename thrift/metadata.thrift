/*
 * Copyright 2012-2014 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.metadata
#@namespace scala edu.jhu.hlt.miser

include "uuid.thrift"

typedef uuid.UUID UUID

/**
 * A struct that holds UUIDs for all theories that a particular
 * annotation was based upon (and presumably requires).
 *
 * Producers of TheoryDependencies should list all stages that they
 * used in constructing their particular annotation. They do not, 
 * however, need to explicitly label *each* stage; they can label
 * only the immediate stage before them.
 * 
 * Examples:
 * 
 * If you are producing a Tokenization, and only used the
 * SentenceSegmentation in order to produce that Tokenization, list
 * only the single SentenceSegmentation UUID in sentenceTheoryList.
 *
 * In this example, even though the SentenceSegmentation will have
 * a dependency on some SectionSegmentation, it is not necessary
 * for the Tokenization to list the SectionSegmentation UUID as a
 * dependency. 
 *
 * If you are a producer of EntityMentions, and you use two
 * POSTokenTagging and one NERTokenTagging objects, add the UUIDs for
 * the POSTokenTagging objects to posTagTheoryList, and the UUID of
 * the NER TokenTagging to the nerTagTheoryList.
 *
 * In this example, because multiple annotations influenced the 
 * new annotation, they should all be listed as dependencies.
 */
struct TheoryDependencies {
  1: optional list<UUID> sectionTheoryList
  2: optional list<UUID> sentenceTheoryList
  3: optional list<UUID> tokenizationTheoryList
  4: optional list<UUID> posTagTheoryList
  5: optional list<UUID> nerTagTheoryList
  6: optional list<UUID> lemmaTheoryList
  7: optional list<UUID> langIdTheoryList
  8: optional list<UUID> parseTheoryList
  9: optional list<UUID> dependencyParseTheoryList
  10: optional list<UUID> tokenAnnotationTheoryList
  11: optional list<UUID> entityMentionSetTheoryList
  12: optional list<UUID> entitySetTheoryList
  13: optional list<UUID> situationMentionSetTheoryList
  14: optional list<UUID> situationSetTheoryList
  15: optional list<UUID> communicationsList
}

//===========================================================================
// Metadata
//===========================================================================

/** 
 * Analytic-specific information about an attribute or edge. Digests
 * are used to combine information from multiple sources to generate a
 * unified value. The digests generated by an analytic will only ever
 * be used by that same analytic, so analytics can feel free to encode
 * information in whatever way is convenient. 
 */
struct Digest {
  /** 
   * The following fields define various ways you can store the
   * digest data (for convenience). If none of these meets your
   * needs, then serialize the digest to a byte sequence and store it
   * in bytesValue. 
   */
  1: optional binary bytesValue
  2: optional i64 int64Value
  3: optional double doubleValue
  4: optional string stringValue
  5: optional list<i64> int64List
  6: optional list<double> doubleList
  7: optional list<string> stringList
}

/** 
 * Metadata associated with an annotation or a set of annotations,
 * that identifies where those annotations came from. 
 */
struct AnnotationMetadata {
  /** 
   * The name of the tool that generated this annotation. 
   */
  1: required string tool

  /** 
   * The time at which this annotation was generated (in unix time
   * UTC -- i.e., seconds since January 1, 1970). 
   */
  2: required i64 timestamp

  /** 
   * Confidence score. To do: define what this means!
   */
  3: optional double confidence

  /** 
   * A Digest, carrying over any information the annotation metadata
   * wishes to carry over.
   */
  4: optional Digest digest

  /**
   * The theories that supported this annotation. 
   * 
   * An empty field indicates that the theory has no 
   * dependencies (e.g., an ingester).
   */
  5: optional TheoryDependencies dependencies
  
  /**
   * An integer that represents a ranking for systems
   * that output k-best lists. 
   * 
   * For systems that do not output k-best lists, 
   * the default value (1) should suffice.
   */
  6: required i32 kBest = 1
}
