# What is Apache Solr™?

Solr is the blazing-fast, open source, multi-modal search platform built on Apache Lucene.
It powers full-text, vector, analytics, and geospatial search at many of the world's largest organizations.
Other major features include Kubernetes integration, streaming, highlighting, faceting, and spellchecking.

Learn more on [Solr's homepage](https://solr.apache.org) and in the [Solr Reference Guide](https://solr.apache.org/guide/solr/).

# Supported tags and respective `Dockerfile` links

See [Docker Hub](https://hub.docker.com/_/solr?tab=tags) for a list of image tags available to pull.
Note that the Apache Solr project does not support any releases older than the current major release series, despite whatever tags are published.

The official Dockerfile is released along-side Solr.
Therefore the project has decided to not support changes to Dockerfiles after release.
Changes must be made to [github.com/apache/solr](https://github.com/apache/solr), which will then be included in the next targeted release.

# About this repository

This repository is available on [github.com/apache/solr-docker](https://github.com/apache/solr-docker), and the official build is on the [Docker Hub](https://hub.docker.com/_/solr/).

The Dockerfiles are generated upon release from [github.com/apache/solr](https://github.com/apache/solr).

Please refer to the [developer documentation](dev-docs/README.md) for information on how this repository is maintained & automated.  
**WARNING: Do not modify this repo manually unless you have read through the developer documentation first.**

# License

Solr is licensed under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0).

This repository is licensed under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0).

Copyright 2015-2022 The Apache Software Foundation

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

# User Feedback

## Issues

Please report issues with this docker image on via [Apache Solr JIRA](https://issues.apache.org/jira/projects/SOLR). But please first reach out via the users@solr mailing list linked in the community information below.

For general questions about Solr, see the [Community information](http://solr.apache.org/community.html), in particular the users@solr mailing list.

## Contributing

If you want to contribute to Solr, see the [How To Contribute](http://solr.apache.org/community.html#how-to-contribute).

# History

This project was started in 2015 by [Martijn Koster](https://github.com/makuk66). In 2019 maintainership and copyright was transferred to the Apache Solr project. Many thanks to Martijn for all your contributions over the years!

