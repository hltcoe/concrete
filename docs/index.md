# Getting started

On this page, we'll work toward getting users started with Concrete. This
document is not intended to be comprehensive tutorial, but rather a starting
point for exploration.

## What is Concrete?

Concrete is a data serialization format for NLP. It replaces ad-hoc XML, CSV, or
programming language-specific serialization as a way of storing document- and
sentence- level annotations. Concrete is based on Apache Thrift and thus works
cross-platform and in almost all popular programming languages, including
Javascript, C++, Java, and Python. To learn more about design considerations and
motivation, have a look at the white paper,
Ferraro et al., 2014: [Concretely Annotated Corpora](http://www.akbc.ws/2014/submissions/akbc2014_submission_18.pdf).
For details about the Concrete data format, see
[the Concrete schema](http://hltcoe.github.io/concrete/schema/).

In addition to data serialization, we provide Concretely annotated data! We've
done the hard work of running a variety of tools, such as, Stanford's NLP
pipeline and HLTCOE/JHU NLP tools, on an abundance of data. For more information,
See [the Excellent HLT website](http://hltcoe.github.io/).

## Table of Contents

* [Getting started](#getting-started)
  * [What is Concrete?](#what-is-concrete?)
  * [Data Format](#data-format)
  * [Table of Contents](#table-of-contents)
  * [Quick Start](#quick-start)
    * [Step 0: Install concrete-python](#step-0-install-concrete-python)
    * [Step 1: Get some data](#step-1-get-some-data)
    * [Step 2: What's in this file?](#step-2-what's-in-this-file?)
* [Programming with Concrete](#programming-with-concrete)
  * [Python](#python)
  * [Java](#java)

## Data Format

### Capturing Document Structure

A
[Communication](http://hltcoe.github.io/concrete/schema/communication.html#Struct_Communication)
is the primary document model. A Communication's full document text is
stored in the `Communication.text` string field; a Communication's
`id` may be a headline, URL, or some other identifying/characterizing
feature. Communications have
[Section](http://hltcoe.github.io/concrete/schema/structure.html#Struct_Section)s,
which themselves have
[Sentence](http://hltcoe.github.io/concrete/schema/structure.html#Struct_Sentence)s. A
Sentence has a
[Tokenization](http://hltcoe.github.io/concrete/schema/structure.html#Struct_Tokenization),
which is where
[DependencyParse](http://hltcoe.github.io/concrete/schema/structure.html#Struct_DependencyParse)s,
Constituent
[Parse](http://hltcoe.github.io/concrete/schema/structure.html#Struct_Parse)s,
and other sentence-level (syntactic) structures are
stored. Token-level annotations, like part of speech and named entity
labels, are stored as
[TokenTagging](http://hltcoe.github.io/concrete/schema/structure.html#Struct_TokenTagging)s
within a Tokenization. All of these structures and annotation objects
have a unique identifier
([UUID](http://hltcoe.github.io/concrete/schema/uuid.html#Struct_UUID)). UUIDs
act as pointers: they allow annotations to be cross-referenced with
others.

### Global Annotations

Semantic, discourse and coreference annotations can cut across
different sentences. Therefore, they are stored at the Communication
level. Semantic and discourse annotations, like frame semantic parses,
are stored as
[SituationMention](http://hltcoe.github.io/concrete/schema/situations.html#Struct_SituationMention)s
within
[SituationMentionSet](http://hltcoe.github.io/concrete/schema/situations.html#Struct_SituationMentionSet)s,
while individual _mentions_ of entities are stored as
[EntityMention](http://hltcoe.github.io/concrete/schema/entities.html#Struct_EntityMention)s
within
[EntityMentionSet](http://hltcoe.github.io/concrete/schema/entities.html#Struct_EntityMentionSet)s. While
EntityMentions and SituationMentions both can ground out in specific
tokens (using UUIDs to cross-reference), SituationMentions can ground
out in EntityMentions or, recursively, other SituationMentions. If
coreference decisions are made, then individual mentions can be
clustered together into either
[SituationSet](http://hltcoe.github.io/concrete/schema/situations.html#Struct_SituationSet)s
or
[EntitySet](http://hltcoe.github.io/concrete/schema/entities.html#Struct_EntitySet)s.

## Quick Start

Now we're going to step through how to look at some Concrete
data. This is meant to get our feet wet. It will not cover the all of
the annotation types listed above in [Data Format](#data-format). It
relies on the `concrete-python` utility library, which also has a
number of useful utility (command line) scripts.

We've also provided a Docker image containing the latest concrete, and
Java and Python libraries. This can be found on
[Dockerhub](https://hub.docker.com/r/hltcoe/concrete/):

```
$ docker pull hltcoe/concrete
$ docker run -i -t hltcoe/concrete:latest /bin/bash
#
```


### Step 0: Install concrete-python

First step, install the Python utility library, either directly to your machine


```
$ pip install concrete
```

or by running the Docker image, as above.

### Step 1: Get some data

```
wget 'https://github.com/hltcoe/quicklime/blob/master/agiga_dog-bites-man.concrete?raw=true' -O example.concrete
```

### Step 2: What's in this file?

#### 2.1 Quicklime Communication viewer

Regardless of how you're ingesting the data, it's probably a good idea to view
the contents of a .comm file using Quicklime. It stands up a mini-webserver that
visualizes the data. Install Quicklime using:

```
pip install quicklime
```

To view a Concrete file:

    $ qlook.py <path-to>/example.concrete
    Listening on http://localhost:8080/
    Hit Ctrl-C to quit.

Now, open your web browser and go to the link printed to the screen
``http://localhost:8080/``. For more information about the Quicklime project,
check out the [Quicklime GitHub repo](https://github.com/hltcoe/quicklime).

#### 2.2 Command-line tools

In addition to Quicklime, ``concrete-inspect.py`` is another tool for viewing
the contents of Concrete files. This utility was made available when you
installed ``concrete-python``, so you can use it in any directory. Below is some
example usage. For further usage, use the script's ``--help`` option.

##### 2.2.1 CoNLL-style output

    $ concrete-inspect.py example.concrete --pos --ner --lemmas --dependency
    INDEX TOKEN     LEMMA    POS NER    HEAD
    ----- -----     -----    --- ---    ----
    1     John      John     NNP PERSON 4
    2     ’s        ’s       POS O      1
    3     daughter  daughter NN  O      4
    4     Mary      Mary     NNP PERSON 5
    5     expressed express  VBD O      0
    6     sorrow    sorrow   NN  O      5
    7     .         .        .   O

##### 2.2.2 Parse tree

    $ concrete-inspect.py example.concrete --treebank
    (ROOT
      (S (NP (NP (NNP John)
                 (POS ’s))
             (NN daughter)
             (NNP Mary))
         (VP (VBD expressed)
             (NP (NN sorrow)))
         (. .)))

# Programming with Concrete

## Python

To install the Python library for concrete, use pip, as described previously:

```
pip install concrete
```

### Read a Communication from a file

You can read a Concrete Communication object from a file as follows.

```python
from concrete.util import read_communication_from_file
comm = read_communication_from_file('/path/to/communication.concrete')
```

### Iterate over sentences

The sections and sentences of a communication are represented as lists and can be traversed accordingly:

```python
for section in comm.sectionList:
    for sentence in section.sentenceList:
        tokenization = sentence.tokenization
        # do something with sentence tokenization...
```

### Get entity mentions

By default, concrete-python also adds convenience attributes to several data types when deserializing them.  So, for example, you can access an entity's mentions directly from the entity object using the `mentionList` attribute, even though there is no such field in the Concrete schema itself:

```python
for entitySet in comm.entitySetList:
    for entity in entitySet.entityList:
        print(f'Entity: {entity.canonicalName}')
        for mention in entity.mentionList:
            print(f'* Mention: {mention.text}')
```

See [add_references_to_communication](https://concrete-python.readthedocs.io/en/stable/concrete.util.references.html#concrete.util.references.add_references_to_communication) for more information about convenience attributes added during deserialization.

## Java

### Installation

If you're using Java, you would use the following dependencies from Maven Central, which correspond to [the v4.15.0 tag of the concrete-java GitHub repository](https://github.com/hltcoe/concrete-java/tree/v4.15.0):

```xml
<dependency>
  <groupId>edu.jhu.hlt</groupId>
  <artifactId>concrete-core</artifactId>
  <version>4.15.0</version>
</dependency>
<dependency>
  <groupId>edu.jhu.hlt</groupId>
  <artifactId>concrete-util</artifactId>
  <version>4.15.0</version>
</dependency>
```

### Read a Communication from a file

You can read in a Concrete file to a Communication object as follows.

```java
CompactCommunicationSerializer ser = new CompactCommunicationSerializer();
Communication comm = ser.fromPathString("/path/to/communication.concrete");
```

### Iterate over sentences

From there, you can just walk the Communication object as you would any other in
Java. The [thrift spec](http://hltcoe.github.io/concrete/schema/communication.html)
defines the data structures. For example, you could iterate through the
sentences as follows.

```java
for (Section cSection : comm.getSectionList()) {
    for (Sentence cSent : cSection.getSentenceList()) {
        Tokenization cToks = cSent.getTokenization();
        // ...do something with the sentence...
    }
}
```

### Get the entities and situations

To get the entities and situations you'd do something like this:

```java
// Get the entities.
List<EntityMentionSet> cEmsList = comm.getEntityMentionSetList();
EntityMentionSet cEms = cEmsList.get(0); // Since there's only one.
// Get the relations.
List<SituationMentionSet> cSmsList = comm.getSituationMentionSetList();
SituationMentionSet cSms = cSmsList.get(0); // Since there's only one.
```
