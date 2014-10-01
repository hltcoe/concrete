/*
 * Copyright 2012-2014 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.language
namespace cpp concrete
#@namespace scala edu.jhu.hlt.miser

include "metadata.thrift"
include "uuid.thrift"

/** 
 * A theory about what languages are present in a given communication
 * or piece of communication.  Note that it is possible to have more
 * than one language present in a given communication. 
 */
struct LanguageIdentification {
  /**
   * Unique identifier for this language identification.
   */
  1: required uuid.UUID uuid

  /**
   * Information about where this language identification came from.
   */
  2: required metadata.AnnotationMetadata metadata

  /** 
   * A list mapping from a language to the probability that that
   * language occurs in a given communication.  Each language code should
   * occur at most once in this list.  The probabilities do <i>not</i>
   * need to sum to one -- for example, if a single communication is known
   * to contain both English and French, then it would be appropriate
   * to assign a probability of 1 to both langauges.  (Manually
   * annotated LanguageProb objects should always have probabilities
   * of either zero or one; machine-generated LanguageProbs may have
   * intermediate probabilities.) 
   * 
   * Note: The string key should represent the ISO 639-3 three-letter code.
   */
  3: required map<string,double> languageToProbabilityMap
}
