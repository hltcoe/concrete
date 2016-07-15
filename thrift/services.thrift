/*
 * Copyright 2012-2016 Johns Hopkins University HLTCOE. All rights reserved.
 * See LICENSE in the project root directory.
 */
include "metadata.thrift"
include "communication.thrift"
include "ex.thrift"

namespace java edu.jhu.hlt.concrete.services
namespace py concrete.services

/**
 * DEPRECATION NOTICE: This interface has been replaced by
 * the ServiceAnnotation interface in the concrete-services
 * package. All new development based on thrift services
 * and concrete should be based on that repo. This is only
 * left for historical, yet-to-be-updated services: do not
 * implement new services with this interface.
 * 
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
