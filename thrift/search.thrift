/*
 * Copyright 2016-2023 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete.search
namespace py concrete.search
namespace cpp concrete

include "communication.thrift"
include "services.thrift"
include "structure.thrift"
include "uuid.thrift"
include "metadata.thrift"
include "entities.thrift"

/**
 * What are we searching over
 */
enum SearchType {
  COMMUNICATIONS
  SECTIONS
  SENTENCES
  ENTITIES
  ENTITY_MENTIONS
  SITUATIONS
  SITUATION_MENTIONS
}

/**
 * A search provider describes its capabilities with a list of search type and language pairs.
 */
struct SearchCapability {
  /**
   * A type of search supported by the search provider
   */
  1: required SearchType type

  /**
   * Language that the search provider supports.
   * Use ISO 639-2/T three letter codes.
   */
  2: required string lang
}

/**
 * Wrapper for information relevant to a (possibly structured) search.
 */
struct SearchQuery {
  /**
   * Individual words, or multiword phrases, e.g., 'dog', 'blue
   * cheese'.  It is the responsibility of the implementation of
   * Search* to tokenize multiword phrases, if so-desired.  Further,
   * an implementation may choose to support advanced features such as
   * wildcards, e.g.: 'blue*'.  This specification makes no
   * committment as to the internal structure of keywords and their
   * semantics: that is the responsibility of the individual
   * implementation.
   */
  1: optional list<string> terms

  /**
   * e.g., "what is the capital of spain?"
   *
   * questions is a list in order that possibly different phrasings of
   * the question can be included, e.g.: "what is the name of spain's
   * capital?"
   */
  2: optional list<string> questions

  /**
   * Refers to an optional communication that can provide context for the query.
   */
  3: optional string communicationId

  /**
   * Refers to a sequence of tokens in the communication referenced by communicationId.
   */
  4: optional structure.TokenRefSequence tokens

  /** 
   * The input from the user provided in the search box, unmodified
   */
  5: optional string rawQuery

  /**
   * optional authorization mechanism
   */
  6: optional string auths

  /**
   * Identifies the user who submitted the search query
   */
  7: optional string userId

  /**
   * Human readable name of the query.
   */
  8: optional string name

  /**
   * Properties of the query or user.
   * These labels can be used to group queries and results by a domain or group of
   * users for training. An example usage would be assigning the geographical region
   * as a label ("spain"). User labels could be based on organizational units ("hltcoe").
   */
  9: optional list<string> labels

  /**
   * This search is over this type of data (communications, sentences, entities)
   */
  10: required SearchType type

  /**
   * The language of the corpus that the user wants to search.
   * Use ISO 639-2/T three letter codes.
   */
  11: optional string lang

  /**
   * An identifier of the corpus that the search is to be performed over.
   */
  12: optional string corpus

  /**
   * The maximum number of candidates the search service should return.
   */
  13: optional i32 k

  /**
   * An optional communication used as context for the query.
   * If both this field and communicationId is populated, then it is
   * assumed the ID of the communication is the same as communicationId.
   */
  14: optional communication.Communication communication
}

/**
 * An individual element returned from a search.  Most/all methods
 * will return a communicationId, possibly with an associated score.
 * For example if the target element type of the search is Sentence
 * then the sentenceId field should be populated.
 */
struct SearchResultItem {
  // e.g., nytimes_145
  1: optional string communicationId

  /** 
   * The UUID of the returned sentence, which appears in the
   * communication referenced by communicationId.
   */
  2: optional uuid.UUID sentenceId

  /**
   * Values are not restricted in range (e.g., do not have to be
   * within [0,1]).  Higher is better.
   *
   */
  3: optional double score

  /**
   * If SearchType=ENTITY_MENTIONS then this field should be populated.
   * Otherwise, this field may be optionally populated in order to
   * provide a hint to the client as to where to center a
   * visualization, or the extraction of context, etc.
   */
  4: optional structure.TokenRefSequence tokens

  /**
   * If SearchType=ENTITIES then this field should be populated.
   */
  5: optional entities.Entity entity
}

/**
 * Single wrapper for results from all the various Search* services.
 */
struct SearchResult {
  /**
   * Unique identifier for the results of this search.
   */
  1: required uuid.UUID uuid

  /**
   * The query that led to this result.
   * Useful for capturing feedback or building training data.
   */
  2: required SearchQuery searchQuery

  /**
   * The list is assumed sorted best to worst, which should be
   * reflected by the values contained in the score field of each
   * SearchResult, if that field is populated.
   */
  3: optional list<SearchResultItem> searchResultItems

  /**
   * The system that provided the response: likely use case for
   * populating this field is for building training data.  Presumably
   * a system will not need/want to return this object in live use.
   */
  4: optional metadata.AnnotationMetadata metadata

  /**
   * The dominant language of the search results.
   * Use ISO 639-2/T three letter codes.
   * Search providers should set this when possible to support downstream processing.
   * Do not set if it is not known.
   * If multilingual, use the string "multilingual".
   */
  5: optional string lang
}

service SearchService extends services.Service {
  /**
   * Perform a search specified by the query
   */
  SearchResult search(1: SearchQuery query) throws (1: services.ServicesException ex)

  /**
   * Get a list of search type-language pairs
   */
  list<SearchCapability> getCapabilities() throws (1: services.ServicesException ex)

  /**
   * Get a corpus list from the search provider
   */
  list<string> getCorpora() throws (1: services.ServicesException ex)  
}

/**
 * The search proxy service provides a single interface to multiple search providers
 */
service SearchProxyService extends services.Service {
  /**
   * Specify the search provider when performing a search
   */
  SearchResult search(1: SearchQuery query, 2: string provider) throws (1: services.ServicesException ex)

  /**
   * Get a list of search providers behind the proxy
   */
  list<string> getProviders() throws (1: services.ServicesException ex)

  /**
   * Get a list of search type and language pairs for a search provider
   */
  list<SearchCapability> getCapabilities(1: string provider) throws (1: services.ServicesException ex)

  /**
   * Get a corpus list for a search provider
   */
  list<string> getCorpora(1: string provider) throws (1: services.ServicesException ex)
}

/**
 * Feedback values
 */
enum SearchFeedback {
  NEGATIVE = -1
  NONE = 0
  POSITIVE = 1
}

service FeedbackService extends services.Service {
  /**
   * Start providing feedback for the specified SearchResults.
   * This causes the search and its results to be persisted.
   */
  void startFeedback(1: SearchResult results) throws (1: services.ServicesException ex)

  /**
   * Provide feedback on the relevance of a particular communication to a search
   */
  void addCommunicationFeedback(1: uuid.UUID searchResultsId, 2: string communicationId, 3: SearchFeedback feedback) throws (1: services.ServicesException ex)

  /**
   * Provide feedback on the relevance of a particular sentence to a search
   */
  void addSentenceFeedback(1: uuid.UUID searchResultsId, 2: string communicationId, 3: uuid.UUID sentenceId, 4: SearchFeedback feedback) throws (1: services.ServicesException ex)
}
