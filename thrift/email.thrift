/*
 * Copyright 2012-2014 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.email
#@namespace scala edu.jhu.hlt.miser

/** 
 * An email address, optionally accompanied by a display_name. These
 * values are typically extracted from strings such as:
 * <tt> "John Smith" &lt;john\@xyz.com&gt; </tt>.
 *
 * \see RFC2822 <http://tools.ietf.org/html/rfc2822>
 */
struct EmailAddress {
  1: optional string address
  2: optional string displayName
}

/** 
 * Extra information about an email communication instance. 
 */
struct EmailCommunicationInfo {
  // Information extracted from headers:
  1: optional string messageId
  2: optional string contentType
  3: optional string userAgent
  4: optional list<string> inReplyTo //!< defined by RFC 822, RFC 2822
  5: optional list<string> reference //!< defined by RFC 1036, RFC 2822
  6: optional EmailAddress senderAddress
  7: optional EmailAddress returnPathAddress
  8: optional list<EmailAddress> toAddress
  9: optional list<EmailAddress> ccAddress
  10: optional list<EmailAddress> bccAddress
}
