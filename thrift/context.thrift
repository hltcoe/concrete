/*
 * Copyright 2012-2018 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.context
namespace cpp concrete

/**
 * A structure intended to convey context about a particular
 * Concrete communication.
 *
 * Contexts are intended to be used to convey meta-communication
 * information to analytics via an RPC method. It is expected that
 * services consuming or producing Contexts are coupled,
 * delivering an agreed upon format that is capable of
 * being interpreted and processed between two particular services.
 *
 * Currently, it is being used to transmit hypotheses alongside
 * concrete communications for AIDA.
 */
struct Context {

  /**
   * The contents of the Context. Services should agree
   * upon what the expected format of the contents are
   * (e.g. JSON, RDF) between themselves.
   */
  1: optional string contents
}
