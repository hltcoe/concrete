/*
 * Copyright 2012-2014 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.spans
namespace cpp concrete.spans
#@namespace scala edu.jhu.hlt.miser

//===========================================================================
// Spans in Text/Audio
//===========================================================================

/** 
 * A span of text within a single communication, identified by a pair
 * of zero-indexed character offsets into a Thrift string. Thrift strings
 * are encoded using UTF-8:
 *   https://thrift.apache.org/docs/types
 * The offsets are character-based, not byte-based - a character with a
 * three-byte UTF-8 representation only counts as one character.
 *
 * NOTE: This span represents a best guess, or 'provenance':
 * it cannot be guaranteed that this text span matches the _exact_
 * text of the original document, but is the annotation's best
 * effort at such a representation.    
 */
struct TextSpan {
  /** 
   * Start character, inclusive. 
   */
  1: required i32 start

  /** 
   * End character, exclusive 
   */
  2: required i32 ending
}

/** 
 * A span of audio within a single communication, identified by a
 * pair of time offests. Time offsets are zero-based.
 *
 * NOTE: This span represents a best guess, or 'provenance':
 * it cannot be guaranteed that this text span matches the _exact_
 * text of the original document, but is the annotation's best
 * effort at such a representation. 
 */
struct AudioSpan {
  /**
   * Start time (in seconds)
   */ 
  1: required i64 start

  /**
   * End time (in seconds)
   */
  2: required i64 ending
}
