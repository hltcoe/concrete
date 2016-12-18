/*
 * Copyright 2012-2015 Johns Hopkins University HLTCOE. All rights reserved.
 * See LICENSE in the project root directory.
 */
namespace java edu.jhu.hlt.concrete.services
namespace py concrete.exceptions
namespace cpp concrete

/**
 * An exception to be used with Concrete thrift
 * services.
 */
exception ConcreteThriftException {
  /*
   * The explanation (why the exception occurred)
   */
  1: required string message

  /*
   * The serialized exception
   */
  2: optional binary serEx
}
