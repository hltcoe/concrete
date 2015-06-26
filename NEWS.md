# News

### Concrete v4.6 - 2015-6-26
* Added new fields to [email.thrift](thrift/email.thrift) to better
support/describe email messages.
* Added a new type, [SpanLink](thrift/structure.thrift#L457), to
support linking between documents (e.g., mapping URLs within a
document).
* Added documentation about how to support pro-drop.
* Fixed a few documentation issues.

### Concrete v4.5 - 2015-5-24
Added an optional field, [ConstituentRef](thrift/structure.thrift#L91), to both
`MentionArgument`s and `SituationMention`s. This field allows references to
Constituent objects within a Parse object.

### Concrete v4.4 - 2015-2-18
Added an optional field, mentionSetId, to EntitySet. This field stores
the UUID of an EntityMentionSet.

When present, this field indicates that all Entities in the EntitySet
contain mentions in the referenced EntityMentionSet.
