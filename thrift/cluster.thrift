/*
 * Copyright 2012-2015 Johns Hopkins University HLTCOE. All rights reserved.
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
 * A member of a 'cluster'. 
 * 
 * Contains a communication ID, an Entity|Situation(Mention)Set ID,
 * and an element ID that identifies the specific
 * Entity|Situation(Mention) associated with this object.
 */ 
struct ClusterMember {
  /**
   * The UUID of the Communication this ClusterMember is associated with.
   */
  1: required uuid.UUID communicationId

  /**
   * The UUID of the Entity|Situation(Mention)Set this ClusterMember
   * is associated with.
   */
  2: required uuid.UUID setId

  /**
   * The UUID of the specific EntityMention, Entity, SituationMention,
   * or Situation that this ClusterMember is tied to.
   */
  3: required uuid.UUID elementId
}

/**
 * A structure that represents a cluster of Communications.
 * 
 * This structure allows for  specific grouping of ClusterMembers, 
 * as well as other Clusters that this Cluster object considers children.
 */
struct Cluster {
  /**
   * A list of integers that represent indices into a list of ClusterMember
   * objects (likely represented in a Clustering object).
   */
  1: optional list<i32> clusterMemberIndexList
  
  /**
   * Confidence values for members of 'memberIndexList' field. 
   */ 
  2: optional list<double> confidenceList

  /**
   * A list of integers that represent indices into a list of Cluster objects,
   * used to represent child Clusters associated with this particular Cluster.
   */
  3: optional list<i32> childIndexList
}

/**
 * A structure that represents a "clustering" of Communications, to support
 * cross-document coreference tasks. 
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
   * A complete list of ClusterMember objects that this Clustering holds.
   */
  3: optional list<ClusterMember> clusterMemberList

  /**
   * A complete list of Cluster objects that this Clustering holds.
   */
  4: optional list<Cluster> clusterList

  /**
   * A list of integers that represent root Clusters. These integers should be
   * indices into the 'clusterList' object.
   */
  5: optional list<i32> rootClusterIndexList
}
