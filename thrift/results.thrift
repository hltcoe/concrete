/*
 * Copyright 2016 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete.services.results
namespace py concrete.services.results
namespace cpp concrete

include "services.thrift"
include "uuid.thrift"
include "search.thrift"
include "communication.thrift"

service ResultsServerService extends services.Service {
  /**
   * Register the specified search result for annotation.
   *
   * If a name has not been assigned to the search query, one will be generated.
   * This service also requires that the user_id field be populated in the SearchQuery.
   */
  void registerSearchResult(1: search.SearchResult result, 2: services.AnnotationTaskType taskType) throws (1: services.ServicesException ex)

  /**
   * Get a list of search results for a particular annotation task
   * Set the limit to 0 to get all relevant search results
   */
  list<search.SearchResult> getSearchResults(1: services.AnnotationTaskType taskType, 2: i32 limit) throws (1: services.ServicesException ex)

  /**
   * Get a list of search results for a particular annotation task filtered by a user id
   * Set the limit to 0 to get all relevant search results
   */
  list<search.SearchResult> getSearchResultsByUser(1: services.AnnotationTaskType taskType, 2: string userId, 3: i32 limit) throws (1: services.ServicesException ex)

  /**
   * Get the most recent search results for a user
   */
  search.SearchResult getLatestSearchResult(1: string userId) throws (1: services.ServicesException ex)

  /**
   * Get a search result object
   */
  search.SearchResult getSearchResult(1: uuid.UUID searchResultId) throws (1: services.ServicesException ex)

  /**
   * Start an annotation session
   * Returns a session id used in future session calls
   */
  uuid.UUID startSession(1: uuid.UUID searchResultId, 2: services.AnnotationTaskType taskType) throws (1: services.ServicesException ex)

  /**
   * Stops an annotation session
   */
  void stopSession(1: uuid.UUID sessionId) throws (1: services.ServicesException ex)

  /**
   * Get next chunk of data to annotate
   * The client should use the Retriever service to access the data
   */
  list<services.AnnotationUnitIdentifier> getNextChunk(1: uuid.UUID sessionId) throws (1: services.ServicesException ex)

  /**
   * Submit an annotation for a session
   */
  void submitAnnotation(1: uuid.UUID sessionId, 2: services.AnnotationUnitIdentifier unitId, 3: communication.Communication communication) throws (1: services.ServicesException ex)
}
