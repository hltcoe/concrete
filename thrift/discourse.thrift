namespace java edu.jhu.hlt.concrete
namespace py concrete.discourse
#@namespace scala edu.jhu.hlt.miser

include "metadata.thrift"
include "uuid.thrift"

/**
 * A reference to an Entity in a Communication.
 */
struct EntityRef {
  1: required UUID entityId                // type=Entity
  2: required UUID communicationId        // type=Communication
}

/**
 * A reference to a Situation in a Communication.
 */
struct SituationRef {
  1: required UUID situationId                // type=Situation
  2: required UUID communicationId        // type=Communication
}

/**
 * Represents one Entity in a cross-doc situation coref/alignment.
 */
struct DiscourseEntity {
  1: required UUID uuid
  2: required list<EntityRef> entityRefList                        // all mentions of this entity
  3: optional double confidence
}

/**
 * Represents one Situation in a cross-doc situation coref/alignment.
 */
struct DiscourseSituation {
  1: required UUID uuid
  2: required list<SituationRef> situationRefList                // all mentions of this situation
  3: optional double confidence
}

/**
 * A theory of cross-doc Entity/Situtation coreference.
 */
struct DiscourseAnnotation {        // come in gold and synthetic varieties
  /**
   * The ID associated with this DiscourseAnnotation.
   */
  1: required UUID uuid

  /**
   * The metadata associated with the tool responsible for suggesting this DiscourseAnnotation.
   */
  2: optional metadata.AnnotationMetadata metadata

  /**
   * A set of DiscourseEntities suggested by this DiscourseAnnotation object.
   */
  3: required list<DiscourseEntity> discourseEntityList                        // all entities mentioned in this Discourse
  
  /**
   * A set of DiscourseSituations suggested by this DiscourseAnnotation object.
   */
  4: required list<DiscourseSituation> discourseSituationList                // all situations mentioned in this Discourse
}


/**
 * A meaniningful set of Communications, possibly
 * with some coreference annotations.
 */
struct Discourse {        
  // the ID associated with this Discourse object.
  1: required UUID uuid

  /**
   * The tool that identified this set of Communications
   * (not the tool that determined any coreference assessments).
   */
  2: optional metadata.AnnotationMetadata metadata

  /**
   * Theories about the coreference relationships between
   * Entity or Situtation discussed in this set of Communications.
   */
  3: required list<DiscourseAnnotation> annotationList
}
