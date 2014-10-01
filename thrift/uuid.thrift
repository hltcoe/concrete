/*
 * Copyright 2012-2014 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.uuid
namespace cpp concrete

struct UUID {
  /**
   * A string representation of a UUID, in the format of:
   * <pre>
   * 550e8400-e29b-41d4-a716-446655440000 
   * </pre>
   */
  1: required string uuidString
}
