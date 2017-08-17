# Getting started

In this document, we'll work toward getting users started with Concrete. This
document is not intended to be comprehensive tutorial, but rather a starting
point for exploration.

## What is Concrete?

Concrete is a data serialization format for NLP. It replaces ad-hoc XML, CSV, or
programming language-specific serialization as a way of storing document- and
sentence- level annotations. Concrete is based on Apache Thrift and thus works
cross-platform and in almost all popular programming languages, including
Javascript, C++, Java, and Python. To learn more about design considerations and
motivation, have a look at the white paper,
[Ferraro et al. (2014)](http://cs.jhu.edu/~ferraro/papers/ferraro-concrete-2014.pdf). The
details of the data format (schema) are described
[here](http://hltcoe.github.io/concrete/schema/).

In addition to data serialization, we provide Concretely annotated data! We've
done the hard work of running a variety of tools, such as, Stanford's NLP
pipeline and HLTCOE/JHU NLP tools, on an abundance of data. For more information
on data release, see the Concrete homepage.

## Table of Contents

* [Getting started](#getting-started)
  * [What is Concrete?](#what-is-concrete?)
  * [Data Format](#data-format)
  * [Table of Contents](#table-of-contents)
  * [Quick Start](#quick-start)
    * [Step 0: Install concrete-python](#step-0-install-concrete-python)
    * [Step 1: Get some data.](#step-1-get-some-data.)
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

### Step 1: Get some data.

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

##### 2.2.1 CoNLL-style output.

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

Below we describe the specifics for using Concrete from [Python](#python) or [Java](#java).

## Python

We provide a brief introduction to concrete-python here; for more information
see
[the online documentation](http://concrete-python.readthedocs.io/en/latest/).

One place to look for example code is the handy
``concrete-inspect.py`` script. Below, we'll walk through a simplified version
of this script for simplicity.

### Installation

If you're using Python, you can install the latest release of
concrete-python (which provides the Python package ``concrete``) via pip:

    $ pip install concrete

### Read a Communication from a file

To read in Communication object from a file  you'd do this:

```python
>>> import concrete.util
>>> comm = concrete.util.read_communication_from_file('example.concrete')
```

### Walk the Data Structures

Then you can walk the object just as you would any other in Python. The
[thrift spec](http://hltcoe.github.io/concrete/schema/communication.html) defines the
data structures.

### Iterate over sentences and print taggings

The following code prints sentences and tags in CoNLL format, similar
``concrete-inspect.py``.

```python
for section in comm.sectionList:
    for sentence in section.sentenceList:

        # Columns of CoNLL-style output go here.
        taggings = []

        # Token text
        taggings.append([x.text for x in sentence.tokenization.tokenList.tokenList])

        if sentence.tokenization.tokenTaggingList is not None:
            # Accumulate all token taggings.
            for tagging in sentence.tokenization.tokenTaggingList:
                taggings.append([x.tag for x in tagging.taggedTokenList])

        if sentence.tokenization.dependencyParseList is not None:
            # Read dependency arcs from dependency parse tree. (Deps start at zero.)
            head = [-1]*len(sentence.tokenization.tokenList.tokenList)
            for arc in sentence.tokenization.dependencyParseList[0].dependencyList:
                head[arc.dep] = arc.gov

            # Add head index to taggings
            taggings.append(head)

        # Transpose the list. Format and print each row.
        for row in zip(*taggings):
            print '\t'.join('%15s' % x for x in row)

        print

```

Note: It is good practice to check for ``None`` on each annotation layer because
each layer is optional. When a layer is not available it is ``None``, when it is
empty it's often an empty list.

Expected output:

```
           John            John             NNP          PERSON               1
          Smith           Smith             NNP          PERSON               9
              ,               ,               ,               O              -1
        manager         manager              NN               O               1
             of              of              IN               O               3
           ACME            ACME             NNP    ORGANIZATION               6
            INC             INC             NNP    ORGANIZATION               4
              ,               ,               ,               O              -1
            was             was            AUXD               O               9
            bit             bit              RB               O              -1
             by              by              IN               O               9
              a               a              DT               O              12
            dog             dog              NN               O              10
             on              on              IN               O              12
          March           March             NNP            DATE              13
           10th            10th              CD            DATE              14
              ,               ,               ,            DATE              -1
           2013            2013              CD            DATE              14
              .               .               .               O              -1

             He              he             PRP               O               1
           died             die             VBD               O              -1
              !               !               .               O              -1

           John            John             NNP          PERSON               3
             's              's             POS               O               0
       daughter        daughter              NN               O               3
           Mary            Mary             NNP          PERSON               4
      expressed         express             VBD               O              -1
         sorrow          sorrow              NN               O               4
              .               .               .               O              -1
```

### Print Entities

Print information for all Entities and their EntityMentions (coreference
resolution).

```python
for entitySet in comm.entitySetList:
    for ei, entity in enumerate(entitySet.entityList):
        print 'Entity %s (%s)' % (ei, entity.canonicalName)
        for i, mention in enumerate(entity.mentionList):
            print '  Mention %s: %s' % (i, mention.text)
        print
    print
```

Expected output:

```
Entity 0 (John Smith , manager of ACME INC ,)
  Mention 0: John Smith , manager of ACME INC ,
  Mention 1: John Smith
  Mention 2: manager of ACME INC
  Mention 3: He
  Mention 4: John 's
```


### Print SituationMentions

Print SituationMentions (relation extraction).

Our previous example file doesn't have situations annotated, so we'll need
another Concrete file to test our code with.

```
$ wget 'https://github.com/hltcoe/quicklime/blob/master/serif_example.concrete?raw=true' -O serif_example.concrete
```

This file has run BBN-SERIF's relation and event extractor.

```python
import concrete.util
comm = concrete.util.read_communication_from_file('serif_example.concrete')

if comm.situationMentionSetList is None:
    print 'Situation mention annotations not available for this document.'

else:
    for i, situationMentionSet in enumerate(comm.situationMentionSetList):
        if situationMentionSet.metadata:
            print 'Situation Set %d (%s):' % (i, situationMentionSet.metadata.tool)
        else:
            print 'Situation Set %d:' % i
        for j, situationMention in enumerate(situationMentionSet.mentionList):
            print 'SituationMention %d-%d:' % (i, j)
            print '    text', situationMention.text
            print '    situationType', situationMention.situationType
            for k, arg in enumerate(situationMention.argumentList):
                print '    Argument %d:' % k
                print '      role', arg.role
                if arg.entityMention:
                    print '      entityMention', arg.entityMention.text
                if arg.situationMention:
                    print '      situationMention:'
                    print '        text', situationMention.text
                    print '        situationType', situationMention.situationType
            print
        print
```

Expected output:

```
Situation Set 0 (Serif: relations):
SituationMention 0-0:
    text None
    situationType ORG-AFF.Employment
    Argument 0:
      role Role.RELATION_SOURCE_ROLE
      entityMention manager of ACME INC
    Argument 1:
      role Role.RELATION_TARGET_ROLE
      entityMention ACME INC

SituationMention 0-1:
    text None
    situationType PER-SOC.Family
    Argument 0:
      role Role.RELATION_SOURCE_ROLE
      entityMention John
    Argument 1:
      role Role.RELATION_TARGET_ROLE
      entityMention daughter


Situation Set 1 (Serif: events):
SituationMention 1-0:
    text died
    situationType Life.Die
    Argument 0:
      role Victim
      entityMention He
```

## Java

### Installation

If you're using Java, you would use the following dependencies from Maven Central, which correspond to the v.4.4.4 tag of the concrete-java GitHub repo:
https://github.com/hltcoe/concrete-java

```xml
<dependency>
  <groupId>edu.jhu.hlt</groupId>
  <artifactId>concrete-core</artifactId>
  <version>4.4</version>
</dependency>
<dependency>
  <groupId>edu.jhu.hlt</groupId>
  <artifactId>concrete-util</artifactId>
  <version>4.4.4</version>
</dependency>
```

### Read a Communication from a file

You can read in a Concrete file to a Communication object as follows.

```java
CompactCommunicationSerializer ser = new CompactCommunicationSerializer();
Communication comm = ser.fromPathString(commFile.getAbsolutePath());
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
