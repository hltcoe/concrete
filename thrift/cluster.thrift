/*
 * Copyright 2012-2023 Johns Hopkins University HLTCOE. All rights reserved.
 * This software is released under the 2-clause BSD license.
 * See LICENSE in the project root directory.
 */

namespace java edu.jhu.hlt.concrete
namespace py concrete.clustering
namespace cpp concrete
#@namespace scala edu.jhu.hlt.miser

include "uuid.thrift"
include "metadata.thrift"

/**
 * An item being clustered. Does not designate cluster _membership_, as in
 * "item x belongs to cluster C", but rather just the item ("x" in this
 * example). Membership is indicated through Cluster objects.  An item may be a
 * Entity, EntityMention, Situation, SituationMention, or technically anything
 * with a UUID.
 */ 
struct ClusterMember {
  /**
   * UUID of the Communication which contains the item specified by 'elementId'.
   * This is ancillary info assuming UUIDs are indeed universally unique.
   */
  1: required uuid.UUID communicationId

  /**
   * UUID of the Entity|Situation(Mention)Set which contains the item specified by 'elementId'.
   * This is ancillary info assuming UUIDs are indeed universally unique.
   */
  2: required uuid.UUID setId

  /**
   * UUID of the EntityMention, Entity, SituationMention, or Situation that
   * this item represents. This is the characteristic field.
   */
  3: required uuid.UUID elementId
}

/**
 * A set of items which are alike in some way.  Has an implicit id which is the
 * index of this Cluster in its parent Clustering's 'clusterList'.
 */
struct Cluster {
  /**
   * The items in this cluster.  Values are indices into the
   * 'clusterMemberList' of the Clustering which contains this Cluster.
   */
  1: optional list<i32> clusterMemberIndexList
  
  /**
   * Co-indexed with 'clusterMemberIndexList'. The i^{th} value represents the
   * confidence that mention clusterMemberIndexList[i] belongs to this cluster.
   */ 
  2: optional list<double> confidenceList

  /**
   * A set of clusters (implicit ids/indices) from which this cluster was
   * created. This cluster should represent the union of all the items in all
   * of the child clusters.  (For hierarchical clustering only).
   */
  3: optional list<i32> childIndexList
}

/**
 * An (optionally) hierarchical clustering of items appearing across a set of
 * Communications (intra-Communication clusterings are encoded by Entities and
 * Situations).  An item may be a Entity, EntityMention, Situation,
 * SituationMention, or technically anything with a UUID.
 */ 
struct Clustering {
  
  /**
   * UUID for this Clustering object.
   */
  1: required uuid.UUID uuid

  /**
   * Metadata for this Clustering object.
   */
  2: required metadata.AnnotationMetadata metadata
  
  /**
   * The set of items being clustered.
   */
  3: optional list<ClusterMember> clusterMemberList

  /**
   * Clusters of items. If this is a hierarchical clustering, this may contain
   * clusters which are the set of smaller clusters.
   * Clusters may not "overlap", meaning (for all clusters X,Y):
   *   X \cap Y \neq \emptyset \implies X \subset Y \vee Y \subset X
   */
  4: optional list<Cluster> clusterList

  /**
   * A set of disjoint clusters (indices in 'clusterList') which cover all
   * items in 'clusterMemberList'. This list must be specified for hierarchical
   * clusterings and should not be specified for flat clusterings.
   */
  5: optional list<i32> rootClusterIndexList
}
