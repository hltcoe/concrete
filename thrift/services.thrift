/*
 * Copyright 2016-2017 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete.services
namespace py concrete.services
namespace cpp concrete

include "uuid.thrift"

/**
 * An exception to be used with Concrete services.
 */
exception ServicesException {
  /**
   * The explanation (why the exception occurred)
   */
  1: required string message

  /**
   * The serialized exception
   */
  2: optional binary serEx
}

/**
 * An exception to be used when an invoked method has
 * not been implemented by the service.
 */
exception NotImplementedException {
  /**
   * The explanation (why the exception occurred)
   */
  1: required string message

  /**
   * The serialized exception
   */
  2: optional binary serEx
}

/**
 * Contact information for the asynchronous communications.
 * When a client contacts a server for a job that takes a significant amount of time,
 * it is often best to implement this asynchronously.
 * We do this by having the client stand up a server to accept the results and 
 * passing that information to the original server.
 * The server may want to create a new thrift client on every request or maintain
 * a pool of clients for reuse.
 */
struct AsyncContactInfo {
  1: required string host
  2: required i32 port
}

/**
 * Annotation Tasks Types
 */
enum AnnotationTaskType {
  TRANSLATION = 1
  NER = 2
  TOPICID = 3
}

/**
 * An annotation unit is the part of the communication to be annotated.
 */
enum AnnotationUnitType {
  COMMUNICATION = 1
  SENTENCE = 2
}

/**
 * An annotation unit is the part of the communication to be annotated.
 * It can be the entire communication or a particular sentence in the communication.
 * If the sentenceID is null, the unit is the entire communication
 */
struct AnnotationUnitIdentifier {
  /**
   * Communication identifier for loading data
   */
  1: required string communicationId

  /**
   * Sentence identifer if annotating sentences
   */
  2: optional uuid.UUID sentenceId
}

/**
 * Each service is described by this info struct.
 * It is for human consumption and for records of versions in deployments.
 */
struct ServiceInfo {
  /**
   * Name of the service
   */
  1: required string name

  /**
   * Version string of the service.
   * It is preferred that the services implement semantic versioning: http://semver.org/ 
   * with version strings like x.y.z
   */
  2: required string version

  /**
   * Description of the service
   */
  3: optional string description
}

/**
 * Base service that all other services should inherit from
 */
service Service {
  /**
   * Get information about the service
   */
  ServiceInfo about()

  /**
   * Is the service alive?
   */
  bool alive();
}
