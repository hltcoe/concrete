TODO: Add a Table of Contents

# What is Concrete?

Concrete is a data serialization format for NLP. It replaces ad-hoc
XML or CSV files as a way of storing document- and sentence- level
annotations. 

Its first use was in Ferraro et al. (2014). The details of the data
format are described at http://hltcoe.github.io/ under "Concrete
schema documentation". The same site also includes tools for working
with the data using either Java or Python. The underlying
representation is Apache Thrift, so other language bindings are easy,
though we don't have public releases of them right now.

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

## Installation

If you're using Python, you can install the v.4.4.3 tag of the concrete-python GitHub repo. Instructions are in README.md.
https://github.com/hltcoe/concrete-python

## Read a Communication from a file

To read in Communication object from a file  you'd do this:

```python
import concrete.inspect 
import concrete.util
comm = concrete.util.read_communication_from_file(args.communication_file)
```

## Walk the Data Structures

TODO: Replace the links to concrete_inspect.py with short code snippets.

Then you can walk the object just as you would any other in
Python. The [thrift
spec](http://hltcoe.github.io/concrete/communication.html) defines the
data structures. 

### Iterate over sentences

For example, you could [print the sentences and tags
in CONLL format](https://github.com/hltcoe/concrete-python/blob/master/concrete/inspect.py#L11)

### Print the entities and situations

You could [print the entities](https://github.com/hltcoe/concrete-python/blob/master/concrete/inspect.py#L72),
or [print the relations](https://github.com/hltcoe/concrete-python/blob/master/concrete/inspect.py#L165).

## Printing parts of a Communication at the Command Line (concrete_inspect.py)

As it happens, these rather tutorial-like examples above of how
to walk the data structure can also be used at the command line from
the concrete_inspect.py utility
(https://github.com/hltcoe/concrete-python/tree/master/scripts) --
another handy visualization tool.

