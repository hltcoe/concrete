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
   * Source sentences to summarize.
   */
  3: optional list<uuid.UUID> sourceTokenizationUuids
  /**
   * Source communications to summarize.
   */
  2: optional list<uuid.UUID> sourceCommunicationUuids
  /**
   * Source communication to summarize.
   */
  4: optional communication.Communication sourceCommunication
}

/**
 * Only one of the summary* fields should be populated.
 */
struct Summary {
  /**
   * Pre-formatted text.
   */
  1: optional string summaryText

  /**
   * Tokenized text with no annotations.
   */
  2: optional list<string> summaryTokens

  /**
   * Annotated summary text.
   */
  3: optional communication.Communication summaryCommunication
}

service SummarizationService extends services.Service {
  Summary summarize(1: SummarizationRequest query) throws (1: services.ServicesException ex)
}

