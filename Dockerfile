
# Base image
FROM ubuntu:16.04
MAINTAINER Paul Murrell <paul@stat.auckland.ac.nz>

# add CRAN PPA
RUN apt-get update && apt-get install -y apt-transport-https
RUN echo 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial/' > /etc/apt/sources.list.d/cran.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# Install additional software
# R stuff
RUN apt-get update && apt-get install -y \
    xsltproc \
    r-base=3.4* \ 
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    bibtex2html \
    subversion 

# Set up keyboard so do not get prompted during build
COPY ./keyboard /etc/default/keyboard
# Set up Xvfb so docker run can work off-screen
RUN apt-get update && apt-get install -y \
    xvfb \
    metacity 
ENV DISPLAY :1
# Ambiance theme for metacity
RUN apt-get install -y light-themes

# Examples in report
RUN apt-get update && apt-get install -y \
    firefox

# For building the report
RUN Rscript -e 'install.packages(c("knitr", "devtools"), repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("xml2", "1.1.1", repos="https://cran.rstudio.com/")'

# System requirements for packages used in the report
RUN apt-get update && apt-get install -y \
    libcairo2-dev \
    fontforge \
    ghostscript \
    phantomjs \
    r-cran-rjava \
    pandoc

# Fonts
RUN apt-get update && apt-get install -y \
    texlive-fonts-extra \
    fonts-crosextra-carlito 

# Packages used in the report
RUN Rscript -e 'library(devtools); install_version("xtable", "1.8-2", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("gdtools", "0.1.7", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("formattable", "0.2.0.1", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("httpuv", "1.4.5", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("Rook", "1.1-1", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("extrafontdb", "1.0", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("Rttf2pt1", "1.3.4", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("gridGraphics", "0.3-0", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("rmarkdown", "1.8", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("ggplot2", "3.0.0", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("gridExtra", "2.3", repos="https://cran.rstudio.com/")'

# Using COPY will update (invalidate cache) if the tar ball has been modified!
# COPY DOM_0.6-0.tar.gz /tmp/
# RUN R CMD INSTALL /tmp/DOM_0.6-0.tar.gz
# To be replace with things like ...
# RUN Rscript -e 'library(devtools); install_github("pmur002/DOM@v0.6-0")'

RUN Rscript -e 'library(devtools); install_github("pmur002/DOM@v0.6-0")'
RUN Rscript -e 'library(devtools); install_github("pmur002/extrafont@v0.18")'
RUN Rscript -e 'library(devtools); install_github("pmur002/gyre@v1.0-0")'
RUN Rscript -e 'library(devtools); install_github("pmur002/courier@v1.0-0")'
RUN Rscript -e 'library(devtools); install_github("pmur002/layoutengine@v0.1-0")'
# dependencies=FALSE to avoid attempt to update 'rJava'
RUN Rscript -e 'library(devtools); install_github("pmur002/layoutenginecssbox@v0.1-0", dependencies=FALSE)'
RUN Rscript -e 'library(devtools); install_github("pmur002/layoutenginephantomjs@v0.1-0")'
RUN Rscript -e 'library(devtools); install_github("pmur002/layoutenginedom@v0.1-0")'

RUN apt-get update && apt-get install -y locales && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# Make fonts available to R (and establish font databases and caches)
# locale set up MUST precede this so that font set up uses correct locale
RUN Rscript -e 'library(gdtools); sys_fonts()'
RUN Rscript -e 'library(extrafont); font_import(prompt=FALSE)'
RUN Rscript -e 'library(extrafont); font_install("gyre")'
RUN Rscript -e 'library(extrafont); font_install("courier")'

