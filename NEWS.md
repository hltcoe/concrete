# News

### Concrete v4.5 - 2015-5-24
Added an optional field, [ConstituentRef](thrift/structure.thrift#L91), to both
`MentionArgument`s and `SituationMention`s. This field allows references to
Constituent objects within a Parse object.

### Concrete v4.4 - 2015-2-18

Added an optional field, mentionSetId, to EntitySet. This field stores
the UUID of an EntityMentionSet.

When present, this field indicates that all Entities in the EntitySet
contain mentions in the referenced EntityMentionSet.
