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
[here](http://hltcoe.github.io/concrete/). Also, the
[Concrete homepage](http://hltcoe.github.io/) is a pointer to additional
documentation and resources.

In addition to data serialization, we provide Concretely annotated data! We've
done the hard work of running a variety of tools, such as, Stanford's NLP
pipeline and HLTCOE/JHU NLP tools, on an abundance of data. For more information
on data release, see the Concrete homepage.

## Step 0: Install concrete-python

    sudo pip install concrete==4.4.3

## Step 1: Get some data.

    wget 'https://github.com/hltcoe/quicklime/blob/master/agiga_dog-bites-man.concrete?raw=true'
    mv agiga_dog-bites-man.concrete example.concrete

## Step 2: What's in this file?

### 2.1 Quicklime Communication viewer

Regardless of how you're ingesting the data, it's probably a good idea to view
the contents of a .comm file using Quicklime. It stands up a mini-webserver that
visualizes the data. The instructions for installation and starting the
visualization are about three commands -- very simple. See the
[README.md](https://github.com/hltcoe/quicklime) docs on the main page.

    git clone git@github.com:hltcoe/quicklime.git
    cd quicklime
    pip install bottle
    ./qlook.py example.concrete

TODO: screenshot

### 2.2 Command-line tools

In addition to quicklime, ``concrete_inspect.py`` is another handy tool for
viewing the contents of Concrete files. Below is some example usage.

#### 2.2.1 CoNLL-style output.

    $ ./concrete_inspect.py example.concrete --pos --ner --lemmas --dependency
    INDEX TOKEN     LEMMA    POS NER    HEAD
    ----- -----     -----    --- ---    ----
    1     John      John     NNP PERSON 4
    2     ’s        ’s       POS O      1
    3     daughter  daughter NN  O      4
    4     Mary      Mary     NNP PERSON 5
    5     expressed express  VBD O      0
    6     sorrow    sorrow   NN  O      5
    7     .         .        .   O

#### 2.2.2 Parse tree

    $ example.concrete --treebank
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

As it happens, a good introductory example usage of Concrete is our handy
``concrete_inspect.py`` script. Below, we'll walk through stripped down version
of this script for simplicity.

### Installation

If you're using Python, you can install version ``4.4.3`` of the
``concrete-python`` module via pip directly from the Python package index
(PyPI).

    $ sudo pip install concrete==4.4.3

### Read a Communication from a file

To read in Communication object from a file  you'd do this:

```python
>>> import concrete.util
>>> comm = concrete.util.read_communication_from_file('example.comm')
```

### Walk the Data Structures

Then you can walk the object just as you would any other in Python. The
[thrift spec](http://hltcoe.github.io/concrete/communication.html) defines the
data structures.

### Iterate over sentences and print taggings

The following code prints sentences and tags in CoNLL format, similar
``concrete_inspect.py``.

```python
for section in comm.sectionList:
    for sentence in section.sentenceList:

        # Columns of CoNLL-style output go here.
        taggings = []

        # Token text
        taggings.append([x.text for x in sentence.tokenization.tokenList.tokenList])

        # Accumulate all token taggings.
        for tagging in sentence.tokenization.tokenTaggingList:
            taggings.append([x.tag for x in tagging.taggedTokenList])

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

### Print the Entities

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


### Print SitationMentions

Print SitationsMentions (relation extraction).

TODO: Example file doesn't have sitations.


# Java

## Installation

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

## Read a Communication from a file

You can read in a Concrete file to a Communication object as follows.

```java
CompactCommunicationSerializer ser = new CompactCommunicationSerializer();
Communication comm = ser.fromPathString(commFile.getAbsolutePath());
```

## Walk the Data Structures

### Iterate over sentences

From there, you can just walk the Communication object as you would
any other in Java. The [thrift spec](http://hltcoe.github.io/concrete/communication.html) defines the data
structures. For example, you could iterate through the sentences as
follows.

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
