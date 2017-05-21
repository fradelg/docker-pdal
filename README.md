# docker-pdal

PDAL minimal docker image, including support for LAZ clouds

* Based on the new debian:strecth official image
* The main difference with the official image is that some heavy dependencies like VTK, Java, Python or PCL are stripped out. Besides, the code is compiled in a single docker layer resulting in a lightweight image
