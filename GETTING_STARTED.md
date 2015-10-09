Concrete is a data serialization format.

A group of Hopkins researchers developed the Concrete schema for exactly this sort of sharing -- its first use comes from Ferraro et al. (2014). The details of the data format are described at http://hltcoe.github.io/ under "Concrete schema documentation". The same site also includes tools for working with the data using either Java or Python. The underlying representation is Apache Thrift, so other language bindings are easy, though we don't have public releases of them right now -- let me know if you'll need another language. Our ACE data includes, lemmas, tags, dependency parses, constituency parses, chunks, NER, and relations. So hopefully this will also save you some effort if you need any of those extra annotations. I can send along some example Java code that shows how to read in the data (it's very simple boiler plate) -- Mo probably has the equivalent in Python.


The files are in Concrete v.4.4 format. The named entities from ACE 2005 are found in the EntityMentionSet on each Communication. The ACE 2005 relations are found in the SituationMentionSet on each Communication. Each of these is just an object in the thrift spec. (The structure for a SituationMention is intentionally more general than one needs to represent just a relation -- this is so we can encode things like PropBank, FrameNet, and CoNLL-2009 all in the same format.) Each of these objects points to the Tokenization (a sub-object of a Sentence) which contains the appropriate span.

One important detail is that you'll need to create the negative relations from all possible pairs of named entities within each sentence. Plank & Moschitti (2013) used all pairs with at most 3 intervening entities. The main experiments in our paper used all pairs: that is, we dropped the distance restriction since it seemed to add an unnecessary additional complication.

-Matt

# What is Concrete?

Concrete is a data serialization format for NLP. It replaces ad-hoc
XML or CSV files as a way of storing document- and sentence- level
annotations. 

# Concrete Terminology and Concepts

TODO: Define these.

- Communication
- Situations and Entities
- Sentence vs. Tokenization
- Quicklime

# Why use Concrete?

TODO

# Viewing Concrete Communication files

Regardless of how you're ingesting the data, it's probably a good idea
to view the contents of a .comm file using Quicklime. It stands up a
mini-webserver that visualizes the data. The instructions for
installation (via pip) and starting the visualization are about three
commands -- very simple. See the README.md docs on the main page.
https://github.com/hltcoe/quicklime

(You can also visualize the data on the command line using
concrete_inspect.py mentioned below.)

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

# Python


If you're using Python, you can install the v.4.4.3 tag of the concrete-python GitHub repo. Instructions are in README.md.
https://github.com/hltcoe/concrete-python

To read in Communication object from a file  you'd do this:

```python
import concrete.inspect 
import concrete.util
comm = concrete.util.read_communication_from_file(args.communication_file)
```

Then you can walk the object just as you would any other in
Python. The [thrift
spec](http://hltcoe.github.io/concrete/communication.html) defines the
data structures. For example, you could print the sentences and tags
in CONLL format, or you could print the entities, or print the
relations. As it happens, these rather tutorial-like examples of how
to walk the data structure can also be used at the command line from
the concrete_inspect.py utility
(https://github.com/hltcoe/concrete-python/tree/master/scripts) --
another handy visualization tool.

