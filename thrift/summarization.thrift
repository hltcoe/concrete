/*
 * Copyright 2016-2017 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete.summarization
namespace py concrete.summarization
namespace cpp concrete

include "communication.thrift"
include "services.thrift"
include "structure.thrift"
include "uuid.thrift"

enum SummarySourceType {
  /**
   * Specifies that sourceIds is a list of Communication.UUIDs.
   * This can be used for single or multi-document summarization.
   */
  DOCUMENT
  /**
   * Specifies that sourceIds is a list of Tokenization.UUIDs.
   */
  TOKENIZATION
  /** Specifies that sourceIds is a list of Entity.UUIDs */
  ENTITY
}

/**
 * A request to summarize which specifies the length of the desired
 * summary and the text data to be summarized.
 * Either set sourceCommunication or sourceType and sourceIds.
 */
struct SummarizationRequest {
  /**
   * Terms or features pertinent to the query.
   * Can be empty, meaning summarize all source material with
   * no a priori beliefs about what is important to summarize.
   */
  1: optional list<string> queryTerms

  /**
   * Limit on how long the returned summary can be in tokens.
   */
  2: optional i32 maximumTokens

  /**
   * Limit on how long the returned summary can be in characters.
   */
  3: optional i32 maximumCharacters

  /**
   * How to interpret the ids in sourceIds.
   * May be null is sourceIds is null, otherwise must be populated.
   */
  4: optional SummarySourceType sourceType

  /**
   * A list of concrete object ids which serve as the material
   * to summarize.
   */
  5: optional list<uuid.UUID> sourceIds

  /**
   * Alternative to sourceIds+sourceType: provide a Communication
   * of text to summarize.
   */
  6: optional communication.Communication sourceCommunication
}

/**
 * A mention of a concept described in a summary which is thought
 * to be informative. Concepts might be named entities, facts, or
 * events which were determined to be salient in the text being
 * summarized.
 */
struct SummaryConcept {
  /** Location in summaryCommunication of this concept */
  1: optional structure.TokenRefSequence tokens
  /** Short description of the concept being evoked, e.g. "kbrel:bornIn" or "related:ACME_Corp" */
  2: optional string concept
  /** How confident is the system that this concept was evoked by this mention, in [0,1] */
  3: optional double confidence = 1
  /** How informative/important it is that this concept be included in the summary (non-negative). */
  4: optional double utility = 1
}

/**
 * A shortened version of some text, possibly with some concepts
 * annotated as justifications for why particular pieces of the
 * summary were kept.
 */
struct Summary {
  /**
   * Contains the text of the generated summary.
   */
  1: optional communication.Communication summaryCommunication

  /**
   * Concepts mentioned in the summary which are believed to be
   * interesting and/or worth highlighting.
   */
  2: optional list<SummaryConcept> concepts
}

struct SummarizationCapability {
  1: required SummarySourceType type
  2: required string lang
}

service SummarizationService extends services.Service {
  Summary summarize(1: SummarizationRequest query) throws (1: services.ServicesException ex)
  list<SummarizationCapability>  getCapabilities() throws (1: services.ServicesException ex)
}

