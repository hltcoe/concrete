/*
 * Copyright 2016 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete.learn
namespace py concrete.learn
namespace cpp concrete.learn

include "services.thrift"
include "uuid.thrift"
include "communication.thrift"

/**
 * Annotation task including information for pulling data.
 */
struct AnnotationTask {
  /**
   * Type of annotation task
   */
  1: required services.AnnotationTaskType type

  /**
   * Language of the data for the task
   */
  2: optional string language

  /**
   * Entire communication or individual sentences
   */
  3: required services.AnnotationUnitType unitType

  /**
   * Identifiers for each annotation unit
   */
  4: required list<services.AnnotationUnitIdentifier> units
}

/**
 * Annotation on a communication.
 */
struct Annotation {
  /**
   * Identifier of the part of the communication being annotated.
   */
  1: required services.AnnotationUnitIdentifier id

  /**
   * Communication with the annotation stored in it.
   * The location of the annotation depends on the annotation unit identifier
   */
  2: required communication.Communication communication
}

/**
 * The active learning server is responsible for sorting a list of communications.
 * Users annotate communications based on the sort.
 *
 * Active learning is an asynchronous process.
 * It is started by the client calling start().
 * At arbitrary times, the client can call addAnnotations().
 * When the server is done with a sort of the data, it calls submitSort() on the client.
 * The server can perform additional sorts until stop() is called.
 *
 * The server must be preconfigured with the details of the data source to pull communications.
 */
service ActiveLearnerServerService extends services.Service {
  /**
   * Start an active learning session on these communications
   */
  bool start(1: uuid.UUID sessionId, 2: AnnotationTask task, 3: services.AsyncContactInfo contact)

  /**
   * Stop the learning session
   */
  void stop(1: uuid.UUID sessionId)

  /**
   * Add annotations from the user to the learning process
   */
  void addAnnotations(1: uuid.UUID sessionId, 2: list<Annotation> annotations)
}

/**
 * The active learner client implements a method to accept new sorts of the annotation units
 */
service ActiveLearnerClientService extends services.Service {
  /**
   * Submit a new sort of communications to the broker
   */
  void submitSort(1: uuid.UUID sessionId, 2: list<services.AnnotationUnitIdentifier> unitIds)
}

