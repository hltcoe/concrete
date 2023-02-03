# News

* Added optional parameter `canonicalName` to `Situation` structure.
* Added propertyList to Situation(Mention) and Entity(Mention).

### Concrete v4.16 - 2022-12-13
* Added `convert` package including a `ConvertCommunicationService`
  service.
* Added custom `id` fields to `EntityMention`, `Situation`,
  `SituationMention`.

### Concrete v4.15 - 2019-05-09
* Added `Context` structure and `AnnotateWithContextService` service.
  `Context`s are intended to be used to convey additional information
  alongside a `Communication` to be annotated.

### Concrete v4.14 - 2017-08-08
* Removed `constituent` field from `MentionArgument` and
`SituationMention`.
* Added `dependencies` and `constituent` fields to `TokenRefSequence`

### Concrete v4.13 - 2017-05-10
* Added the `summarization` package, which includes the enumeration
`SummarySourceType`, the structs `SummarizationRequest`,
`SummaryConcept`, `Summary`, and `SummarizationCapability`, and the
service `SummarizationService`.
* Added an `id` field to the class `Entity`.
* Added a `rawMentionList` field to the class `Entity`.
* Added an `entity` field to `SearchResultItem`.
* Added `TOPICID` to the `AnnotationTaskType` enumeration

### Concrete v4.12 - 2017-01-10
* Merged `concrete-services` with the main repository.
* Added a `k` field to the class `SearchQuery`.
* Added a `communication` field to the class `SearchQuery`.

### Concrete v4.11 - 2016-10-26
* Added retweeted status fields to the `TwitterInfo` structure,
mirroring the fields representing replies.

### Concrete v4.10 - 2016-07-15
The `4.10` release removes the `Sender` service and deprecates
the `Annotator` service. These new services now live in a project
called `concrete-services`, a parallel set of thrift files
based on `concrete`. See that project for more details.

### Concrete v4.9 - 2016-06-13
The `4.9` release contains an additional service, `Sender`, that
allows `Communication` objects to be sent from clients to an
implementing server.

See the stub [here](thrift/services.thrift#L66).

### Concrete v4.8 - 2015-8-18
* Added service layer to Concrete. The .thrift file can be
viewed [here](thrift/services.thrift).

### Concrete v4.7 - 2015-7-8
* Added section-level `LanguageIdentification` field
to allow language-specific analytics to run over meaningful
content.

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
