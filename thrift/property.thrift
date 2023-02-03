/*
 * Copyright 2012-2023 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.property
namespace cpp concrete
#@namespace scala edu.jhu.hlt.miser

include "metadata.thrift"

/**
 * Attached to situations, entities, or arguments (or mentions thereof)
 * to support multi-label annotations.
 */
struct Property {
  /**
   * The required value of the property.
   */
  1: required string value
  
  /**
   * Metadata to support this particular property object.
   */  
  2: required metadata.AnnotationMetadata metadata
  
  /** 
   * This value is typically boolean, 0.0 or 1.0, but we use a
   * float in order to potentially capture cases where an annotator is
   * highly confident that the value is underspecified, via a value of
   * 0.5.  
   */
  3: optional double polarity
}
