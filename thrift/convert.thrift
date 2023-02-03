/*
 * Copyright 2022-2023 Johns Hopkins University HLTCOE. All rights reserved.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete.convert
namespace py concrete.convert
namespace cpp concrete

include "communication.thrift"
include "services.thrift"

/**
 * Convert service methods for converting between Concrete
 * Communications and other formats.
 */
service ConvertCommunicationService extends services.Service {
  /**
   * Converts a Concrete Communication to another format.
   *
   * The output is encoded as a bytestring.
   * It is up to the implementing service to ensure that
   * the output format is valid.
   *
   * Can throw a ConcreteThriftException upon error
   * (invalid input, etc.).
   */
  binary fromConcrete(1: communication.Communication original) throws (1: services.ServicesException ex)

  /**
   * Converts another format to a Concrete Communication.
   *
   * The input is encoded as a bytestring.
   * It is up to the implementing service to ensure that
   * the input format is valid.
   *
   * Can throw a ConcreteThriftException upon error
   * (invalid input, etc.).
   */
  communication.Communication toConcrete(1: binary original) throws (1: services.ServicesException ex)
}
