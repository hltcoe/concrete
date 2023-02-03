/*
 * Copyright 2012-2023 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.email
namespace cpp concrete
#@namespace scala edu.jhu.hlt.miser

/** 
 * An email address, optionally accompanied by a display_name. These
 * values are typically extracted from strings such as:
 * <tt> "John Smith" &lt;john\@xyz.com&gt; </tt>.
 *
 * \see RFC2822 http://tools.ietf.org/html/rfc2822
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
  4: optional list<string> inReplyToList //!< defined by RFC 822, RFC 2822
  5: optional list<string> referenceList //!< defined by RFC 1036, RFC 2822
  6: optional EmailAddress senderAddress
  7: optional EmailAddress returnPathAddress
  8: optional list<EmailAddress> toAddressList
  9: optional list<EmailAddress> ccAddressList
  10: optional list<EmailAddress> bccAddressList

  //
  // added 2015-6-25 to support email tasks
  //
  
  /*
   * The email folder containing the email, such as "deleted" or "mid-east oil".
   */
  11: optional string emailFolder

  /*
   * The subject of the email. Should also be indicated with a 
   * Section with kind == subject.
   */
  12: optional string subject
  
  /*
   * The email addresses in the quoted messages. Should also be
   * indicated with a Section with kind == 'quoted-addresses'
   */
  13: optional list<string> quotedAddresses

  /*
   * A list of strings representing the paths on disk
   * to any attachments this email had. 
   */
  14: optional list<string> attachmentPaths

  /*
   * The content of this email's salutation. Should also be
   * indicated with a Section with kind == 'salutation'
   */
  15: optional string salutation

  /*
   * The content of this email's signature. Should also be
   * indicated with a Section with kind == 'signature'
   */
  16: optional string signature
}
