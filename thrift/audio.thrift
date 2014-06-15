namespace java edu.jhu.hlt.concrete
namespace py concrete.audio
#@namespace scala edu.jhu.hlt.miser

//===========================================================================
// Audio Data
//===========================================================================

/** 
 * A sound wave. A separate optional field is defined for each
 * suppported format. Typically, a Sound object will only define
 * a single field.
 *
 * Note: we may want to have separate fields for separate channels
 * (left vs right), etc.
 */
struct Sound {
  // Todo: decide what sound-file types we want to support.
  1: optional binary wav
  2: optional binary mp3
  3: optional binary sph

  /** 
   * An absolute path to a file on disk where the sound file can be
   * found. It is assumed that this path will be accessable from any
   * machine that the system is run on (i.e., it should be a shared
   * disk, or possibly a mirrored directory). 
   */
  4: optional string path
}

