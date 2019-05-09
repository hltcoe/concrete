/*
 * Copyright 2016-2017 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete.access
namespace py concrete.access
namespace cpp concrete

include "communication.thrift"
include "services.thrift"

/**
 * Struct containing Communications from the FetchCommunicationService service.
 */
struct FetchResult {
  /**
   * a list of Communication objects that represent the results of the request
   */
  1: required list<communication.Communication> communications
}

/**
 * Struct representing a request for FetchCommunicationService.
 */
struct FetchRequest {
  /**
   * a list of Communication IDs
   */
  1: required list<string> communicationIds
  /**
   * optional authorization mechanism
   */
  2: optional string auths
}

/**
 * Service to fetch particular communications.
 */
service FetchCommunicationService extends services.Service {
  FetchResult fetch(1: FetchRequest request) throws (1: services.ServicesException ex)

  /**
   * Get a list of 'count' Communication IDs starting at 'offset'.  Implementations
   * that do not provide this should throw an exception.
   */
  list<string> getCommunicationIDs(1: i64 offset, 2: i64 count) throws (1: services.NotImplementedException ex)

  /**
   * Get the number of Communications this service searches over.  Implementations
   * that do not provide this should throw an exception.
   */
  i64 getCommunicationCount() throws (1: services.NotImplementedException ex)
}

/**
 * A service that exists so that clients can store Concrete data
 * structures to implementing servers.
 *
 * Implement this if you are creating an analytic that wishes to
 * store its results back to a server. That server may perform
 * validation, write the new layers to a database, and so forth.
 */
service StoreCommunicationService extends services.Service {
  /**
   * Store a communication to a server implementing this method.
   *
   * The communication that is stored should contain the new
   * analytic layers you wish to append. You may also wish to call
   * methods that unset annotations you feel the receiver would not
   * find useful in order to reduce network overhead.
   */
  void store(1: communication.Communication communication) throws (1: services.ServicesException ex)
}
