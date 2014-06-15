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