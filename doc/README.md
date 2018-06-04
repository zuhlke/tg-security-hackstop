# Overview

The idea of the project is to create a potentially vulnerable system, attack it using a variety of typical hacker tools,
and analyse the resulting log files to see whether alerts can be generated when particular attack patterns are recognised.

Our initial approach is to set up an environment within Amazon Web Services (AWS) where we can isolate the hacker tools so they
have no way to attack systems on the public Internet, only our system under test (in a separate subnet). We're installing
Kali Linux and and OWASP's ZAP as attacking systems. WordPress and optionally RocketChat will act as the systems under attack.
Splunk is used as the log aggregator. A machine learning system remains to be identified.

# Coding Tools

IntelliJ IDEA (Community Edition or Ultimate Edition) - download from https://www.jetbrains.com/idea/download -
is used for code and also UML diagrams using the built-in plugin in the Ultimate Edition.

For those without access to the ultimate edition, there is a Chrome extension called Zen UML - https://www.zenuml.com.
WebSequenceDiagrams is particularly for creating sequence diagrams in a variety of styles - https://www.websequencediagrams.com/.
There are also third-party plug-ins for IDEA, such as PlantUML - https://plugins.jetbrains.com/plugin/7017-plantuml-integration.

# General Diagramming Tools

To view / edit diagrams, use yEd (https://www.yworks.com/downloads#yEd)

# Other Tools

To edit textual documents and presentations, use MS Office.
