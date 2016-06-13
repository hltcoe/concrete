/*
 * Copyright 2012-2016 Johns Hopkins University HLTCOE. All rights reserved.
 * See LICENSE in the project root directory.
 */
include "metadata.thrift"
include "language.thrift"
include "structure.thrift"
include "entities.thrift"
include "situations.thrift"
include "ex.thrift"
include "email.thrift"
include "twitter.thrift"
include "audio.thrift"
include "communication.thrift"

namespace java edu.jhu.hlt.concrete.services
namespace py concrete.services

/**
 * Annotator service methods. For concrete analytics that
 * are to be stood up as independent services, accessible
 * from any programming language.
 */
service Annotator {
  /**
   * Main annotation method. Takes a communication as input
   * and returns a new one as output.
   *
   * It is up to the implementing service to verify that
   * the input communication is valid.
   *
   * Can throw a ConcreteThriftException upon error
   * (invalid input, analytic exception, etc.).
   */
  communication.Communication annotate(1: communication.Communication original) throws (1: ex.ConcreteThriftException ex)

  /**
   * Return the tool's AnnotationMetadata.
   */
  metadata.AnnotationMetadata getMetadata()

  /**
   * Return a detailed description of what the particular tool
   * does, what inputs and outputs to expect, etc. 
   *
   * Developers whom are not familiar with the particular
   * analytic should be able to read this string and
   * understand the essential functions of the analytic.
   */
  string getDocumentation()

  /**
   * Indicate to the server it should shut down.
   */
  oneway void shutdown()
}

/**
 * A service that exists so that clients can send Concrete data
 * structures to implementing servers.
 *
 * Implement this if you are creating an analytic that wishes to
 * send its results back to a server. That server may perform
 * validation, write the new layers to a database, and so forth.
 */
service Sender {
  /**
   * Send a communication to a server implementing this method.
   *
   * The communication that is sent back should contain the new
   * analytic layers you wish to append. You may also wish to call
   * methods that unset annotations you feel the receiver would not
   * find useful in order to reduce network overhead.
   */
  oneway void send(1: communication.Communication communication)
}
