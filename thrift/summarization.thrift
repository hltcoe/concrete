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

/**
 * Only one of the source* fields should be populated.
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
   * Source sentences to summarize.
   * The SummarizationService is responsible for dereferencing the UUID
   * and must share a UUID->object store with the requester.
   */
  4: optional list<uuid.UUID> sourceTokenizationUuids

  /**
   * Source communications to summarize.
   * The SummarizationService is responsible for dereferencing the UUID
   * and must share a UUID->object store with the requester.
   */
  5: optional list<uuid.UUID> sourceCommunicationUuids

  /**
   * Source communication to summarize.
   */
  6: optional communication.Communication sourceCommunication

  /**
   * UUID of a source Entity to summarize.
   * The SummarizationService is responsible for dereferencing the UUID
   * and must share a UUID->object store with the requester.
   */
  7: optional uuid.UUID sourceEntityId
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

/**
 * A mention of a concept described in a summary which is thought
 * to be informative. Concepts might be named entities, facts, or
 * events which were determined to be salient in the text being
 * summarized.
 */
struct SummaryConcept {
  1: optional structure.TokenRefSequence tokens
  2: optional string concept
  3: optional double confidence = 1
}

service SummarizationService extends services.Service {
  Summary summarize(1: SummarizationRequest query) throws (1: services.ServicesException ex)
}

