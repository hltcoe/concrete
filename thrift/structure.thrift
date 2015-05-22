/*
 * Copyright 2012-2014 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.structure
namespace cpp concrete
#@namespace scala edu.jhu.hlt.miser

include "metadata.thrift"
include "spans.thrift"
include "uuid.thrift"

//===========================================================================
// Tokens & Tokenizations
//===========================================================================

/** 
 * A single token (typically a word) in a communication. The exact
 * definition of what counts as a token is left up to the tools that
 * generate token sequences.
 *
 * Usually, each token will include at least a text string.
 */
struct Token {
  /** 
   * A 0-based tokenization-relative identifier for this token that
   * represents the order that this token appears in the
   * sentence. Together with the UUID for a Tokenization, this can be
   * used to define pointers to specific tokens. If a Tokenization
   * object contains multiple Token objects with the same id (e.g., in
   * different n-best lists), then all of their other fields *must* be
   * identical as well.
   */
  1: required i32 tokenIndex

  /** 
   * The text associated with this token.
   * Note - we may have a destructive tokenizer (e.g., Stanford rewriting)
   * and as a result, we want to maintain this field.
   */
  2: optional string text

  /** 
   * Location of this token in this perspective's text (.text field).
   * In cases where this token does not correspond directly with any 
   * text span in the text (such as word insertion during MT),
   * this field may be given a value indicating "approximately" where 
   * the token comes from. A span covering the entire sentence may be 
   * used if no more precise value seems appropriate. 
   *
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the document, but is the annotation's best
   * effort at such a representation.    
   */
  3: optional spans.TextSpan textSpan

  /** 
   * Location of this token in the original, raw text (.originalText
   * field).  In cases where this token does not correspond directly
   * with any text span in the original text (such as word insertion
   * during MT), this field may be given a value indicating
   * "approximately" where the token comes from. A span covering the
   * entire sentence may be used if no more precise value seems
   * appropriate.
   *
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original raw document, but is the annotation's best
   * effort at such a representation.    
   */
  4: optional spans.TextSpan rawTextSpan

  /** 
   * Location of this token in the original audio. 
   *
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation.    
   */
  5: optional spans.AudioSpan audioSpan
}

/**
 * A reference to a Constituent within a Parse.
 */
struct ConstituentRef {
  /**
   * The UUID of the Parse that this Constituent belongs to.
   */
  1: required uuid.UUID parseId

  /**
   * The index in the constituent list of this Constituent.
   */
  2: required i32 constituentIndex
}

/** 
 * A list of pointers to tokens that all belong to the same
 * tokenization. 
 */
struct TokenRefSequence {
  /** 
   * The tokenization-relative identifiers for each token that is
   * included in this sequence. 
   */
  1: required list<i32> tokenIndexList

  /** 
   * An optional field that can be used to describe
   * the root of a sentence (if this sequence is a full sentence),
   * the head of a constituent (if this sequence is a constituent),
   * or some other form of "canonical" token in this sequence if,
   * for instance, it is not easy to map this sequence to a another
   * annotation that has a head. 
   *
   * This field is defined with respect to the Tokenization given 
   * by tokenizationId, and not to this object's tokenIndexList.
   */
  2: optional i32 anchorTokenIndex = -1

  /**
   * The UUID of the tokenization that contains the tokens. 
   */
  3: required uuid.UUID tokenizationId

  /**
   * The text span in the main text (.text field) associated with this
   * TokenRefSequence.
   *
   * NOTE: This span represents a best guess, or 'provenance': it
   * cannot be guaranteed that this text span matches the _exact_ text
   * of the original document, but is the annotation's best effort at
   * such a representation.
   */
  4: optional spans.TextSpan textSpan

  /** 
   * The text span in the original text (.originalText field)
   * associated with this TokenRefSequence.
   *
   * NOTE: This span represents a best guess, or 'provenance': it
   * cannot be guaranteed that this text span matches the _exact_ text
   * of the original raw document, but is the annotation's best effort
   * at such a representation.
   */
  5: optional spans.TextSpan rawTextSpan

  /** 
   * The audio span associated with this TokenRefSequence.
   *
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation.    
   */
  6: optional spans.AudioSpan audioSpan
}

struct TaggedToken {
  /** 
   * A pointer to the token being tagged. 
   *
   * Token indices are 0-based. These indices are also 0-based.
   */
  1: optional i32 tokenIndex

  /** 
   * A string containing the annotation.
   * If the tag set you are using is not case sensitive,
   * then all part of speech tags should be normalized to upper case. 
   */
  2: optional string tag

  /** 
   * Confidence of the annotation. 
   */
  3: optional double confidence

  /**
   * A list of strings that represent a distribution of possible
   * tags for this token.
   *
   * If populated, the 'tag' field should also be populated
   * with the "best" value from this list.
   */
  4: optional list<string> tagList

  /**
   * A list of doubles that represent confidences associated with
   * the tags in the 'tagList' field.
   *
   * If populated, the 'confidence' field should also be populated
   * with the confidence associated with the "best" tag in 'tagList'.
   */
  5: optional list<double> confidenceList
}

/** 
 * A theory about some token-level annotation.
 * The TokenTagging consists of a mapping from tokens
 * (using token ids) to string tags (e.g. part-of-speech tags or lemmas).
 *
 * The mapping defined by a TokenTagging may be partial --
 * i.e., some tokens may not be assigned any part of speech tags.
 *
 * For lattice tokenizations, you may need to create multiple
 * part-of-speech taggings (for different paths through the lattice),
 * since the appropriate tag for a given token may depend on the path
 * taken. For example, you might define a separate
 * TokenTagging for each of the top K paths, which leaves all
 * tokens that are not part of the path unlabeled.
 *
 * Currently, we use strings to encode annotations. In
 * the future, we may add fields for encoding specific tag sets
 * (eg treebank tags), or for adding compound tags.
 */
struct TokenTagging {
  /**
   * The UUID of this TokenTagging object.
   */
  1: required uuid.UUID uuid

  /** 
   * Information about where the annotation came from.
   * This should be used to tell between gold-standard annotations
   * and automatically-generated theories about the data 
   */
  2: required metadata.AnnotationMetadata metadata

  /** 
   * The mapping from tokens to annotations.
   * This may be a partial mapping. 
   */
  3: required list<TaggedToken> taggedTokenList

  /**
   * An ontology-backed string that represents the
   * type of token taggings this TokenTagging object
   * produces.
   */ 
  4: optional string taggingType
}

/**
 * A syntactic edge between two tokens in a tokenized sentence.
 */
struct Dependency {
  /**
   * The governor or the head token. 0 indexed.
   */
  1: optional i32 gov = -1  // can be omitted when dep is the root token

  /**
   * The dependent token. 0 indexed.
   */
  2: required i32 dep

  /**
   * The relation that holds between gov and dep.
   */
  3: optional string edgeType
}

/**
 * Information about the structure of a dependency parse.
 * This information is computable from the list of dependencies,
 * but this allows the consumer to make (verified) assumptions
 * about the dependencies being processed.
 */
struct DependencyParseStructure {
  /**
   * True iff there are no cycles in the dependency graph.
   */
  1: required bool isAcyclic

  /**
   * True iff the dependency graph forms a single connected component.
   */
  2: required bool isConnected

  /**
   * True iff every node in the dependency parse has at most
   * one head/parent/governor.
   */
  3: required bool isSingleHeaded

  /**
   * True iff there are no crossing edges in the dependency parse.
   */
  4: required bool isProjective
}

/**
 * Represents a dependency parse with typed edges.
 */
struct DependencyParse {
  1: required uuid.UUID uuid
  2: required metadata.AnnotationMetadata metadata
  3: required list<Dependency> dependencyList
  4: optional DependencyParseStructure structureInformation
}

//===========================================================================
// Parse Trees
//===========================================================================

/** 
 * A single parse constituent (or "phrase"). 
 */
struct Constituent {
  /** 
   * A parse-relative identifier for this consistuent. Together
   * with the UUID for a Parse, this can be used to define
   * pointers to specific constituents. 
   */
  1: required i32 id
  
  /**
   * A description of this constituency node, e.g. the category "NP".
   * For leaf nodes, this should be a word and for pre-terminal nodes
   * this should be a POS tag.
   */
  2: optional string tag

  /*
   * The list of parse constituents that are directly dominated by
   * this constituent. This will be an empty list for leaf nodes.
   */
  3: required list<i32> childList

  /** 
   * The index of the head child of this constituent. I.e., the
   * head child of constituent <tt>c</tt> is
   * <tt>c.children[c.head_child_index]</tt>. A value of -1
   * indicates that no child head was identified. 
   */
  4: optional i32 headChildIndex = -1

  /**
   * The first token (inclusive) of this constituent in the
   * parent Tokenization. Almost certainly should be populated.
   */
  5: optional i32 start

  /**
   * The last token (exclusive) of this constituent in the
   * parent Tokenization. Almost certainly should be populated.
   */
  6: optional i32 ending
}

/** 
 * A theory about the syntactic parse of a sentence.
 *
 * \note If we add support for parse forests in the future, then it
 * will most likely be done by adding a new field (e.g.
 * "<tt>forest_root</tt>") that uses a new struct type to encode the
 * forest. A "<tt>kind</tt>" field might also be added (analogous to
 * <tt>Tokenization.kind</tt>) to indicate whether a parse is encoded
 * using a simple tree or a parse forest.
 */
struct Parse {
  1: required uuid.UUID uuid
  2: required metadata.AnnotationMetadata metadata
  3: required list<Constituent> constituentList
}

struct LatticePath {
  1: optional double weight
  2: required list<Token> tokenList
}

/**
 * Type for arcs. For epsilon edges, leave 'token' blank. 
 */
struct Arc {
  1: optional i32 src //!< state identifier
  2: optional i32 dst //!< state identifier
  3: optional Token token //!< leave empty for epsilon edge
  4: optional double weight //!< additive weight; lower is better
}

/** 
 * A lattice structure that assigns scores to a set of token
 * sequences.  The lattice is encoded as an FSA, where states are
 * identified by integers, and each arc is annotated with an
 * optional tokens and a weight.  (Arcs with no tokens are
 * "epsilon" arcs.)  The lattice has a single start state and a
 * single end state.  (You can use epsilon edges to simulate
 * multiple start states or multiple end states, if desired.)
 * 
 * The score of a path through the lattice is the sum of the weights
 * of the arcs that make up that path.  A path with a lower score
 * is considered "better" than a path with a higher score.  
 * 
 * If possible, path scores should be negative log likelihoods
 * (with base e -- e.g. if P=1, then weight=0; and if P=0.5, then
 * weight=0.693).  Furthermore, if possible, the path scores should
 * be globally normalized (i.e., they should encode probabilities).
 * This will allow for them to be combined with other information
 * in a reasonable way when determining confidences for system
 * outputs.
 *
 * TokenLattices should never contain any paths with cycles.  Every
 * arc in the lattice should be included in some path from the start
 * state to the end state.
 */
struct TokenLattice {
  /*
   * Start state for this token lattice. 
   */
  1: optional i32 startState = 0
  
  /*
   * End state for this token lattice. 
   */
  2: optional i32 endState = 0

  /*
   * The set of arcs that make up this lattice (order is
   * unspecified). 
   */
  3: required list<Arc> arcList

  /*
   * A cached copy of the one-best path through the token lattice.
   * This field must always be kept consistent with the arc-based
   * lattice: if you edit the lattice, then you must either delete
   * this field or ensure that it is up-to-date. 
   */
  4: optional LatticePath cachedBestPath
}

/** 
 * A wrapper around a list of tokens. 
 */
struct TokenList {
  /*
   * An *ordered* list of tokens.
   */
  1 : required list<Token> tokenList
}


/**
 * Enumerated types of Tokenizations
 */
enum TokenizationKind {
  TOKEN_LIST = 1
  TOKEN_LATTICE = 2
}

/** 
 * A theory (or set of alternative theories) about the sequence of
 * tokens that make up a sentence.
 *
 * This message type is used to record the output of not just for
 * tokenizers, but also for a wide variety of other tools, including
 * machine translation systems, text normalizers, part-of-speech
 * taggers, and stemmers.
 *
 * Each Tokenization is encoded using either a TokenList
 * or a TokenLattice. (If you want to encode an n-best list, then
 * you should store it as n separate Tokenization objects.) The
 * "kind" field is used to indicate whether this Tokenization contains
 * a list of tokens or a TokenLattice.
 *
 * The confidence value for each sequence is determined by combining
 * the confidence from the "metadata" field with confidence
 * information from individual token sequences as follows:
 *
 * <ul>
 * <li> For n-best lists:
 * metadata.confidence </li>
 * <li> For lattices:
 * metadata.confidence * exp(-sum(arc.weight)) </li>
 * </ul>
 *
 * Note: in some cases (such as the output of a machine translation
 * tool), the order of the tokens in a token sequence may not
 * correspond with the order of their original text span offsets.
 */
struct Tokenization {
  /*
   * Unique identifier for this tokenization. 
   */ 
  1: required uuid.UUID uuid

  /**
   * Information about where this tokenization came from.
   */
  2: required metadata.AnnotationMetadata metadata
  
  /**
   * A wrapper around an ordered list of the tokens in this tokenization.  
   * This may also give easy access to the "reconstructed text" associated
   * with this tokenization.
   * This field should only have a value if kind==TOKEN_LIST. 
   */
  3: optional TokenList tokenList

  /**
   * A lattice that compactly describes a set of token sequences that
   * might make up this tokenization.  This field should only have a
   * value if kind==LATTICE. 
   */
  4: optional TokenLattice lattice
  
  /**
   * Enumerated value indicating whether this tokenization is
   * implemented using an n-best list or a lattice.
   */
  5: required TokenizationKind kind

  
  6: optional list<TokenTagging> tokenTaggingList
  7: optional list<Parse> parseList
  8: optional list<DependencyParse> dependencyParseList
}

//===========================================================================
// Sentences
//===========================================================================
/**
 * A single sentence or utterance in a communication. 
 */
struct Sentence {
  1: required uuid.UUID uuid
  
  /** 
   * Theories about the tokens that make up this sentence.  For text
   * communications, these tokenizations will typically be generated
   * by a tokenizer.  For audio communications, these tokenizations
   * will typically be generated by an automatic speech recognizer. 
   *
   * The "Tokenization" message type is also used to store the output
   * of machine translation systems and text normalization
   * systems. 
   */
  2: optional Tokenization tokenization

  /**
   * Location of this sentence in the communication text.
   *
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation.    
   */
  3: optional spans.TextSpan textSpan

  /**
   * Location of this sentence in the raw text.
   *
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation.    
   */
  4: optional spans.TextSpan rawTextSpan
  
  /**
   * Location of this sentence in the original audio.
   *
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation.    
   */
  5: optional spans.AudioSpan audioSpan
}

//===========================================================================
// Sections (aka "Regions" or "Zones")
//===========================================================================

/**
 * A single "section" of a communication, such as a paragraph. Each
 * section is defined using a text or audio span, and can optionally
 * contain a list of sentences. 
 */
struct Section { 
  /**
   * The unique identifier for this section. 
   */
  1: required uuid.UUID uuid
  
  /**
   * Theories about how this section is divided into sentences.
   */ 
  2: optional list<Sentence> sentenceList
  
  /**
   * Location of this section in the communication text.
   *
   * NOTE: This text span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation. 
   */
  3: optional spans.TextSpan textSpan

  /**
   * Location of this section in the raw text.
   *
   * NOTE: This text span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation. 
   */
  4: optional spans.TextSpan rawTextSpan

  /**
   * Location of this section in the original audio. 
   * 
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation. 
   */
  9: optional spans.AudioSpan audioSpan

  /**
   * The type of this section.
   */
  5: required string kind
  
  /**
   * The name of the section. For example, a title of a section on 
   * Wikipedia. 
   */
  6: optional string label

  /**
   * Position within the communication with respect to other Sections:
   * The section number, E.g., 3, or 3.1, or 3.1.2, etc. Aimed at
   * Communications with content organized in a hierarchy, such as a Book
   * with multiple chapters, then sections, then paragraphs. Or even a
   * dense Wikipedia page with subsections. Sections should still be
   * arranged linearly, where reading these numbers should not be required
   * to get a start-to-finish enumeration of the Communication's content.
   */
  7: optional list<i32> numberList
}
