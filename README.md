# NOTE: Not vulnerable to Log4J 2 "Log4shell"

Some Docker images *were* vulnerable to one of a pair of vulnerabilities in Log4J 2.
But we have mitigated *[supported](https://hub.docker.com/_/solr?tab=tags)* images (and some others) and re-published them.
You may need to re-pull the image you are using.
For those images prior to 8.11.1, Solr is using a popular technique to mitigate the problem -- setting `log4j2.formatMsgNoLookups`.
The Solr maintainers have deemed this adequate based specifically on how Solr uses logging; it won't be adequate for all projects that use Log4J. 
canning software might alert you to the presence of an older Log4J JAR file, however it can't know if your software (Solr) uses the artifacts in a vulnerable way.
To validate the mitigation being in place, look for `-Dlog4j2.formatMsgNoLookups` in the Args section of Solr's front admin screen.
As of Solr 9.0.0, Solr is using Log4J 2.17.1.

References:
* [CVE-2021-44228](https://nvd.nist.gov/vuln/detail/CVE-2021-44228): Solr _was_ vulnerable to this.
* [CVE-2021-45046](https://nvd.nist.gov/vuln/detail/CVE-2021-45046): Solr _never was_ vulnerable to this.
* [Solr's security bulletin](https://solr.apache.org/security.html#apache-solr-affected-by-apache-log4j-cve-2021-44228)


# Supported tags and respective `Dockerfile` links

See [Docker Hub](https://hub.docker.com/_/solr?tab=tags) for a list of image tags available to pull.
Note that the Apache Solr project doesn't actually support any releases older than the current major release series, despite whatever tags are published.

For more information about this image and its history and all currently supported tags, please see [the relevant manifest file (`library/solr`)](https://github.com/docker-library/official-images/blob/master/library/solr).
This image is updated via pull requests to [the `apache/solr-docker` GitHub repo](https://github.com/apache/solr-docker).
However, the `Dockerfile`s are generated from official Apache Solr releases. See [the `apache/solr` Github repo](https://github.com/apache/solr/tree/main/solr/docker)
for more information on how the Docker image is created, maintained and tested.

# What is Apache Solr™?

Apache Solr is highly reliable, scalable and fault tolerant, providing distributed indexing, replication and load-balanced querying, automated failover and recovery, centralized configuration and more.
Solr powers the search and navigation features of many of the world's largest internet sites.

Learn more on [Solr's homepage](https://solr.apache.org) and in the [Solr Reference Guide](https://solr.apache.org/guide/solr/).

![logo](https://raw.githubusercontent.com/docker-library/docs/master/solr/logo.png)

# Getting started with the Docker image

For information on using the tags 9.0.0 and above, please refer to the [Docker section in the Solr reference guide](https://solr.apache.org/guide/solr/latest/deployment-guide/solr-in-docker.html).

For information on using tags 8 and before, please refer to the [docker-solr repository](https://github.com/docker-solr/docker-solr).

# About this repository

This repository is available on [github.com/apache/solr-docker](https://github.com/apache/solr-docker), and the official build is on the [Docker Hub](https://hub.docker.com/_/solr/).

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

This project was started in 2015 by [Martijn Koster](https://github.com/makuk66). In 2019 maintainership and copyright was transferred to the Apache Lucene/Solr project. Many thanks to Martijn for all your contributions over the years!

