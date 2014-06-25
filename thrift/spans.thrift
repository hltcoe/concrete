/*
 * Copyright 2012-2014 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.spans
#@namespace scala edu.jhu.hlt.miser

//===========================================================================
// Spans in Text/Audio
//===========================================================================

/** 
 * A span of text within a single communication, identified by a pair
 * of character offsets. In this context, a "character offset" is a
 * zero-based count of UTF-16 codepoints. I.e., if you are using
 * Java, or are using a Python build where sys.maxunicode==0xffff,
 * then the "character offset" is an offset into the standard
 * (unicode) string data type. If you are using a Python build where
 * sys.maxunicode==0xffffffff, then you would need to encode the
 * unicode string using UTF-16 before using the character offsets. 
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