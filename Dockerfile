# base upon Debian Buster
FROM debian:buster

# set correct timezone + generic UTF-8 locale
ENV TZ=Europe/Berlin LC_ALL=C.UTF-8

# set workdir ("~" does not work)
WORKDIR /root

# install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
 openjdk-11-jre-headless \
 python3 \
 wget \
 unzip \
 && rm -rf /var/lib/apt/lists/*

# prevent "java.awt.AWTError: Assistive Technology not found: org.GNOME.Accessibility.AtkWrapper" (see https://askubuntu.com/a/723503)
RUN sed -i -e '/^assistive_technologies=/s/^/#/' /etc/java-*-openjdk/accessibility.properties

# download/extract BaseX
RUN wget http://files.basex.org/releases/9.3/BaseX93.zip -O basex.zip \
 && unzip basex.zip -d tools \
 && rm basex.zip

# download/extract/move Saxon HE 9
RUN wget https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/SaxonHE9-9-1-6J.zip/download -O saxon.zip \
 && unzip saxon.zip saxon9he.jar \
 && mv saxon9he.jar tools/basex/lib/custom \
 && rm saxon.zip

# copy Webapp
COPY webapp/*.xqm webapp/
COPY webapp/static/error.xsl webapp/static/
COPY webapp/WEB-INF/*.xml webapp/WEB-INF/
COPY modules modules
COPY .basexhome .

# expose RESTXQ port
EXPOSE 8984

# run BaseX
CMD tools/basex/bin/basexhttp -d