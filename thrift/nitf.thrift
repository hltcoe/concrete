/*
 * Copyright 2012-2014 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

/*
 * Some work was taken from the NYT Annotated corpus, which includes the following
 * copyright info: 
 * 
 * Copyright 2008 The New York Times Company
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.nitf
namespace cpp concrete
#@namespace scala edu.jhu.hlt.miser

struct NITFInfo {
  /**
   * This field specifies the URL of the article, if published online. In some
   * cases, such as with the New York Times, when this field is present, 
   * the URL is preferred to the URL field on articles published on
   * or after April 02, 2006, as the linked page will have richer content.
   */
  1: optional string alternateURL

  /**
   * This field is a summary of the article, possibly written by 
   * and indexing service.
   */
  2: optional string articleAbstract

  /**
   * This field specifies the biography of the author of the article.
   * Generally, this field is specified for guest authors, and not for 
   * regular reporters, except to provide the author's email address.
   */
  3: optional string authorBiography;

  /**
   * The banner field is used to indicate if there has been additional
   * information appended to the articles since its publication. Examples of
   * banners include ('Correction Appended' and 'Editor's Note Appended').
   */
  4: optional string banner

  /**
   * When present, the biographical category field generally indicates that a
   * document focuses on a particular individual. The value of the field
   * indicates the area or category in which this individual is best known.
   * This field is most often defined for Obituaries and Book Reviews. 
   * 
   * <ol>
   * <li>Politics and Government (U.S.)</li>
   * <li>Books and Magazines <li>Royalty</li>
   * </ol>
   */
  5: optional list<string> biographicalCategoryList

  /**
   * If the article is part of a regular column, this field specifies the name
   * of that column.
   * <br />
   * Sample Column Names:
   * <br />
   * <ol>
   * <li>World News Briefs</li>
   * <li>WEDDINGS</li>
   * <li>The Accessories Channel</li>
   * </ol>
   * 
   */
  8: optional string columnName

  /**
   * This field specifies the column in which the article starts in the print
   * paper. A typical printed page in the paper has six columns numbered from
   * right to left. As a consequence most, but not all, of the values for this
   * field fall in the range 1-6.
   */
  9: optional i32 columnNumber

  /**
   * This field specifies the date on which a correction was made to the
   * article. Generally, if the correction date is specified, the correction
   * text will also be specified (and vice versa).
   */
  10: optional i64 correctionDate

  /**
   * For articles corrected following publication, this field specifies the
   * correction. Generally, if the correction text is specified, the
   * correction date will also be specified (and vice versa).
   */
  11: optional string correctionText

  /**
   * This field indicates the entity that produced the editorial content of
   * this document. 
   */
  12: optional string credit

  /**
   * The &quot;dateline&quot; field is the dateline of the article. Generally a dateline
   * is the name of the geographic location from which the article was filed
   * followed by a comma and the month and day of the filing.
   * <br />
   * Sample datelines:
   * <ul>
   * <li>WASHINGTON, April 30</li>
   * <li>RIYADH, Saudi Arabia, March 29</li>
   * <li>ONTARIO, N.Y., Jan. 26</li>
   * </ul>
   * Please note:
   * <ol>
   * <li>The dateline location is the location from which the article was
   * filed. Often times this location is related to the content of the
   * article, but this is not guaranteed.</li>
   * <li>The date specified for the dateline is often but not always the day
   * previous to the publication date.</li>
   * <li>The date is usually but not always specified.</li>
   * </ol>
   */
  13: optional string dateline

  /**
   * This field specifies the day of week on which the article was published.
   * <ul>
   * <li>Monday</li>
   * <li>Tuesday</li> 
   * <li>Wednesday</li> 
   * <li>Thursday</li> 
   * <li>Friday</li> 
   * <li>Saturday</li>
   * <li>Sunday</li>
   * </ul>
   */
  14: optional string dayOfWeek

  /**
   * The &quot;descriptors&quot; field specifies a list of descriptive terms drawn from
   * a normalized controlled vocabulary corresponding to subjects mentioned in
   * the article. 
   * <br />
   * Examples Include:
   * <ol>
   * <li>ECONOMIC CONDITIONS AND TRENDS</li>
   * <li>AIRPLANES</li>
   * <li>VIOLINS</li>
   * </ol>
   */
  15: optional list<string> descriptorList

  /**
   * The feature page containing this article, such as 
   * <ul>
   * <li>Education Page</li>
   * <li>Fashion Page</li>
   * </ul>
   */
  16: optional string featurePage

  /**
   * The &quot;general online descriptors&quot; field specifies a list of descriptors
   * that are at a higher level of generality than the other tags associated
   * with the article.
   * <br />
   * Examples Include:
   * <ol>
   * <li>Surfing</li>
   * <li>Venice Biennale</li>
   * <li>Ranches</li>
   * </ol>
   */
  17: optional list<string> generalOnlineDescriptorList

  /**
   * The GUID field specifies an integer that is guaranteed to be unique for
   * every document in the corpus.
   */
  18: optional i32 guid

  /**
   * This field specifies the headline of the article as it appeared in a
   * print edition.
   */
  19: optional string headline

  /**
   * The kicker is an additional piece of information printed as an
   * accompaniment to a news headline.
   */
  20: optional string kicker

  /**
   * The &quot;lead Paragraph&quot; field is the lead paragraph of the article.
   * Generally this field is populated with the first two paragraphs from the
   * article.
   */
  21: optional list<string> leadParagraphList

  /**
   * The &quot;locations&quot; field specifies a list of geographic descriptors drawn
   * from a normalized controlled vocabulary that correspond to places
   * mentioned in the article. 
   * <br />
   * Examples Include:
   * <ol>
   * <li>Wellsboro (Pa)</li>
   * <li>Kansas City (Kan)</li>
   * <li>Park Slope (NYC)</li>
   * </ol>
   */
  22: optional list<string> locationList

  /**
   * The &quot;names&quot; field specifies a list of names mentioned in the article.
   * <br />
   * Examples Include:
   * <ol>
   * <li>Azza Fahmy</li>
   * <li>George C. Izenour</li>
   * <li>Chris Schenkel</li>
   * </ol>
   */
  23: optional list<string> nameList

  /**
   * This field specifies the desk in the newsroom that
   * produced the article. The desk is related to, but is not the same as the
   * section in which the article appears.
   */
  24: optional string newsDesk

  /**
   * The Normalized Byline field is the byline normalized to the form (last
   * name, first name).
   */
  25: optional string normalizedByline

  /**
   * This field specifies a list of descriptors from a normalized controlled
   * vocabulary that correspond to topics mentioned in the article.
   * <br />
   * Examples Include:
   * <ol>
   * <li>Marriages</li>
   * <li>Parks and Other Recreation Areas</li>
   * <li>Cooking and Cookbooks</li>
   * </ol>
   */
  26: optional list<string> onlineDescriptorList

  /**
   * This field specifies the headline displayed with the article
   * online. Often this differs from the headline used in print.
   */
  27: optional string onlineHeadline

  /**
   * This field specifies the lead paragraph for the online version.
   */
  28: optional string onlineLeadParagraph

  /**
   * This field specifies a list of place names that correspond to geographic
   * locations mentioned in the article.
   * <br />
   * Examples Include:
   * <ol>
   * <li>Hollywood</li>
   * <li>Los Angeles</li>
   * <li>Arcadia</li>
   * </ol>
   */
  29: optional list<string> onlineLocationList

  /**
   * This field specifies a list of organizations that correspond to
   * organizations mentioned in the article.
   * <br />
   * Examples Include:
   * <ol>
   * <li>Nintendo Company Limited</li>
   * <li>Yeshiva University</li>
   * <li>Rose Center</li>
   * </ol>
   */
  30: optional list<string> onlineOrganizationList

  /**
   * This field specifies a list of people that correspond to individuals
   * mentioned in the article.
   * <br/>
   * Examples Include:
   * <ol>
   * <li>Lopez, Jennifer</li>
   * <li>Joyce, James</li>
   * <li>Robinson, Jackie</li>
   * </ol>
   */
  31: optional list<string> onlinePeople

  /**
   * This field specifies the section(s) in which the online version of the article
   * is placed. This may typically be populated from a semicolon (;) delineated list.
   */
  32: optional list<string> onlineSectionList

  /**
   * This field specifies a list of authored works mentioned in the article.
   * <br/>
   * Examples Include:
   * <ol>
   * <li>Matchstick Men (Movie)</li>
   * <li>Blades of Glory (Movie)</li>
   * <li>Bridge & Tunnel (Play)</li>
   * </ol>
   */
  33: optional list<string> onlineTitleList

  /**
   * This field specifies a list of organization names drawn from a normalized
   * controlled vocabulary that correspond to organizations mentioned in the
   * article.
   * <br />
   * Examples Include:
   * <ol>
   * <li>Circuit City Stores Inc</li>
   * <li>Delaware County Community College (Pa)</li>
   * <li>CONNECTICUT GRAND OPERA</li>
   * </ol>
   */
  34: optional list<string> organizationList

  /**
   * This field specifies the page of the section in the paper in which the
   * article appears. This is not an absolute pagination. An article that
   * appears on page 3 in section A occurs in the physical paper before an
   * article that occurs on page 1 of section F. The section is encoded in 
   * the <strong>section</strong> field.
   */
  35: optional i32 page

  /**
   * This field specifies a list of people from a normalized controlled
   * vocabulary that correspond to individuals mentioned in the article.
   * <br />
   * Examples Include:
   * <ol>
   * <li>REAGAN, RONALD WILSON (PRES)</li>
   * <li>BEGIN, MENACHEM (PRIME MIN)</li>
   * <li>COLLINS, GLENN</li>
   * </ol>
   */
  36: optional list<string> peopleList

  /**
   * This field specifies the date of the article's publication.
   */
  37: optional i64 publicationDate

  /**
   * This field specifies the day of the month on which the article was
   * published, always in the range 1-31.
   */
  38: optional i32 publicationDayOfMonth

  /**
   * This field specifies the month on which the article was published in the
   * range 1-12 where 1 is January 2 is February etc.
   */
  39: optional i32 publicationMonth

  /**
   * This field specifies the year in which the article was published. This
   * value is in the range 1987-2007 for this collection.
   */
  40: optional i32 publicationYear

  /**
   * This field specifies the section of the paper in which the article
   * appears. This is not the name of the section, but rather a letter or
   * number that indicates the section.
   */
  41: optional string section

  /**
   * If the article is part of a regular series, this field specifies the name
   * of that column.
   */
  42: optional string seriesName

  /**
   * The slug is a short string that uniquely identifies an article from all
   * other articles published on the same day. Please note, however, that
   * different articles on different days may have the same slug.
   * <ul>
   * <li>30other</li> 
   * <li>12reunion</li>
   * </ul>
   */
  43: optional string slug

  /** 
   * The file from which this object was read. 
   */
  44: optional string sourceFilePath;

  /**
   * This field specifies a list of taxonomic classifiers that place this
   * article into a hierarchy of articles. The individual terms of each
   * taxonomic classifier are separated with the '/' character.
   * <br/>
   * Examples Include:
   * <ol>
   * <li>Top/Features/Travel/Guides/Destinations/North America/United
   * States/Arizona</li>
   * <li>Top/News/U.S./Rockies</li>
   * <li>Top/Opinion</li>
   * </ol>
   */
  45: optional list<string> taxonomicClassifierList

  /**
   * This field specifies a list of authored works that correspond to works
   * mentioned in the article.
   * <br/>
   * Examples Include:
   * <ol>
   * <li>Greystoke: The Legend of Tarzan, Lord of the Apes (Movie)</li>
   * <li>Law & Order (TV Program)</li>
   * <li>BATTLEFIELD EARTH (BOOK)</li>
   * </ol>
   */
  46: optional list<string> titleList

  /**
   * This field specifies a normalized list of terms describing the general
   * editorial category of the article.
   * <br />
   * Examples Include:
   * <ol>
   * <li>REVIEW</li>
   * <li>OBITUARY</li>
   * <li>ANALYSIS</li>
   * </ol>
   */
  47: optional list<string> typesOfMaterialList

  /**
   * This field specifies the location of the online version of the article. The
   * &quot;Alternative Url&quot; field is preferred to this field on articles published
   * on or after April 02, 2006, as the linked page will have richer content.
   */
  48: optional string url

  /**
   * This field specifies the number of words in the body of the article,
   * including the lead paragraph.
   */
  49: optional i32 wordCount
 }
