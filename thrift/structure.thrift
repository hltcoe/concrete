/*
 * Copyright 2012-2014 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.structure
#@namespace scala edu.jhu.hlt.miser

include "metadata.thrift"
include "spans.thrift"
include "uuid.thrift"

typedef uuid.UUID UUID

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
   * A tokenization-relative identifier for this token. Together
   * with the UUID for a Tokenization, this can be used to define
   * pointers to specific tokens. If a Tokenization object contains
   * multiple Token objects with the same id (e.g., in different
   * n-best lists), then all of their other fields *must* be
   * identical as well. 
   */
  // A 0-based index that represents the order that this token appears in the sentence.
  1: required i32 tokenIndex

  /** 
   * The text associated with this token.
   * Note - we may have a destructive tokenizer (e.g., Stanford rewriting)
   * and as a result, we want to maintain this field.
   */
  2: required string text

  /** 
   * Location of this token in the original text. In cases where
   * this token does not correspond directly with any text span in
   * the original text (such as word insertion during MT), this field
   * may be given a value indicating "approximately" where the token
   * comes from. A span covering the entire sentence may be used if
   * no more precise value seems appropriate. 
   *
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation.    
   */
  3: optional spans.TextSpan textSpan

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
   */
  2: optional i32 anchorTokenIndex = -1

  /** 
   * The UUID of the tokenization that contains the tokens. 
   */
  3: required UUID tokenizationId

  /**
   * The text span associated with this TokenRefSequence.
   *
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation.    
   */
  4: optional spans.TextSpan textSpan

  /** 
   * The audio span associated with this TokenRefSequence.
   *
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation.    
   */
  5: optional spans.AudioSpan audioSpan
}

struct TaggedToken {
  /** 
   * A pointer to the token being tagged. 
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
  1: required UUID uuid

  /** 
   * Information about where the annotation came from.
   * This should be used to tell between gold-standard annotations
   * and automatically-generated theories about the data 
   */
  2: optional metadata.AnnotationMetadata metadata

  /** 
   * The mapping from tokens to annotations.
   * This may be a partial mapping. 
   */
  3: required list<TaggedToken> taggedTokenList
}

struct Dependency {
  1: optional i32 gov        // will be null for ROOT token (only)
  2: required i32 dep
  3: optional string edgeType
}

/**
 * Represents a dependency parse with typed edges.
 */
struct DependencyParse {
  1: required UUID uuid
  2: optional metadata.AnnotationMetadata metadata
  3: required list<Dependency> dependencyList
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
  
  2: optional string tag

  /*
   * The list of parse constituents that are directly dominated by
   * this constituent. 
   */
  3: required list<i32> childList

  /** 
   * The list of pointers to the tokens dominated by this
   * constituent. Typically, this field will only be defined for
   * leaf constituents (i.e., constituents with no children). For
   * many parsers, len(tokens) will always be either 1 (for leaf
   * constituents) or 0 (for non-leaf constituents). 
   */
  4: optional TokenRefSequence tokenSequence

  /** 
   * The index of the head child of this constituent. I.e., the
   * head child of constituent <tt>c</tt> is
   * <tt>c.children[c.head_child_index]</tt>. A value of -1
   * indicates that no child head was identified. 
   */
  5: optional i32 headChildIndex = -1
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
  1: required UUID uuid
  2: optional metadata.AnnotationMetadata metadata
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

  /*
   * Optionally provide an explicit representation of the
   * text, as seen by the tokenizer that produced the containing
   * tokenization. When provided, this field gives easy access to 
   * a common form for all tools and annotations relying on this
   * containing tokenization.
   */
  2 : optional string reconstructedText
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
  1: required UUID uuid

  /**
   * Information about where this tokenization came from.
   */
  2: optional metadata.AnnotationMetadata metadata
  
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
  
  6: optional list<TokenTagging> posTagList
  7: optional list<TokenTagging> nerTagList
  8: optional list<TokenTagging> lemmaList
  9: optional list<TokenTagging> langIdList

  10: optional list<Parse> parseList
  11: optional list<DependencyParse> dependencyParseList
  12: optional list<TokenTagging> tokenAnnotationsList
  
  /**
   * A pointer to the sentence from which this Tokenization was generated.
   */
  12: optional UUID sentenceId
}

//===========================================================================
// Sentences
//===========================================================================
/**
 * A single sentence or utterance in a communication. 
 */
struct Sentence {
  1: required UUID uuid
  
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
  2: optional list<Tokenization> tokenizationList

  /**
   * Location of this sentence in the original text.
   *
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation.    
   */
  3: optional spans.TextSpan textSpan
  
  /**
   * Location of this sentence in the original audio.
   *
   * NOTE: This span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation.    
   */
  4: optional spans.AudioSpan audioSpan
}

/** 
 * A theory about how a section of a communication is broken down
 * into sentences (or utterances). The sentences in a
 * SentenceSegmentation should be ordered and non-overlapping. 
 */
struct SentenceSegmentation {
  1: required UUID uuid

  /**
   * Information about where this segmentation came from.
   */  
  2: optional metadata.AnnotationMetadata metadata
  
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
  3: required list<Sentence> sentenceList
  
  /**
   * A UUID pointer to the "parent" Section that this SentenceSegmentation
   * is associated with. 
   */
  4: optional UUID sectionId
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
  1: required UUID uuid
  
  /**
   * Theories about how this section is divided into sentences.
   */ 
  2: optional list<SentenceSegmentation> sentenceSegmentationList
  
  /**
   * Location of this section in the original text.
   *
   * NOTE: This text span represents a best guess, or 'provenance':
   * it cannot be guaranteed that this text span matches the _exact_
   * text of the original document, but is the annotation's best
   * effort at such a representation. 
   */
  3: optional spans.TextSpan textSpan

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
  4: required string kind
  
  /**
   * The name of the section. For example, a title of a section on 
   * Wikipedia. 
   */
  5: optional string label

  /**
   * Position within the communication with respect to other Sections:
   * The section number, E.g., 3, or 3.1, or 3.1.2, etc. Aimed at
   * Communications with content organized in a hierarchy, such as a Book
   * with multiple chapters, then sections, then paragraphs. Or even a
   * dense Wikipedia page with subsections. Sections should still be
   * arranged linearly, where reading these numbers should not be required
   * to get a start-to-finish enumeration of the Communication's content.
   */
  6: optional list<i32> numberList
}

/** 
 * A theory about how a communication is broken down into smaller
 * sections (such as paragraphs). The sections should be ordered
 * and non-overlapping. 
 */
struct SectionSegmentation {
  /**
   * Unique identifier for this segmentation.
   */
  1: required UUID uuid

  /**
   * Information about where this segmentation came from.
   */
  2: optional metadata.AnnotationMetadata metadata

  /**
   * Ordered list of sections in this segmentation.
   */
  3: required list<Section> sectionList
}
