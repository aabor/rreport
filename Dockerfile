# aabor/rreports
# configured for automatic build
FROM rocker/tidyverse:4.0.0

LABEL maintainer="A. A. Borochkin"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ## for some package installs
    cmake \
    ## Nice Google fonts
    fonts-roboto \
    ## used by some base R plots
    ghostscript \
    curl \
    vim \
    tree \
  && apt-get clean    

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py
RUN pip install numpy pandas tabulate

# System dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ## for rJava
    default-jdk \
    ## used to build rJava and other packages
    libbz2-dev \
    libicu-dev \
    liblzma-dev \
    ## system dependency of hunspell (devtools)
    libhunspell-dev \
    ## system dependency of hadley/pkgdown
    libmagick++-dev \
    ## poppler to install pdftools to work with .pdf files
    libpoppler-cpp-dev \
    ## (GSL math library dependencies)
    # for topicmodels on which depends textmineR
    gsl-bin \
    libgsl0-dev \
    ## rdf, for redland / linked data
    librdf0-dev \
    ## for V8-based javascript wrappers
    libv8-dev \
    ## system dependency for igraph
    glpk-utils \
    # Dependencies for gmp
    libgmp-dev \
    # Dependencies for Rmpfr
    libmpfr-dev \
    # Dependencies for qpdf
    qpdf \
    ghostscript \
    && apt-get clean
   
# System utilities
RUN install2.r --error \
  doParallel \
  # Pure R implementation of the ubiquitous log4j package. It offers hierarchic loggers, multiple handlers per logger,
  # level based filtering, space handling in messages and custom formatting.
  logging \
  # JUnit tests
  testthat \
  # Provides two convenience functions assert() and test_pkg() to facilitate testing R packages
  testit \
  # R functions implementing a standard Unit Testing framework, with additional code inspection and report generation tools
  RUnit \   
  # Low-Level R to Java Interface
  rJava \  
  # seamless integration of R and C++
  Rcpp \
  && rm -rf /tmp/downloaded_packages/

# Different file formats support
RUN install2.r --error \ 
    # functions to stream, validate, and prettify JSON data
    jsonlite \
    # archivator
    zip \
    # easy and simple way to read, write and display bitmap images stored in the JPEG format
    png \
    # easy and simple way to read, write and display bitmap images stored in the PNG format
    jpeg \
    # Methods to Convert R Data to YAML and Back
    yaml \
    && rm -rf /tmp/downloaded_packages/

#Additional ggplot packages
RUN install2.r --error \
    # Network Analysis and Visualization
    igraph \
    # Provides text and label geoms for 'ggplot2' that help to avoid overlapping text labels. Labels repel away from
    # each other and away from the data points
    ggrepel \
    # parses and converts LaTeX math formulas to R’s plotmath expressions.
    latex2exp \
    RColorBrewer \
    # easy-to-use functions for creating and customizing 'ggplot2'- based publication ready plots
    ggpubr \
    # tabulate-and-report functions that approximate popular features of SPSS and Microsoft Excel
    janitor \
    && rm -rf /tmp/downloaded_packages/

# Tidyverse like packages
RUN install2.r --error \
  # Computes and displays complex tables of summary statistics. Output may be in LaTeX, HTML, plain text, or an R matrix for further processing
  tables \
  # Flexibly restructure and aggregate data using just two functions: melt and 'dcast'
  reshape2 \
  && rm -rf /tmp/downloaded_packages/

# Database support
RUN install2.r --error \ 
    # Legacy 'DBI' interface to 'MySQL' / 'MariaDB' based on old code ported from S-PLUS
    RMySQL \
    # provide a common API for access to SQL 1 -based database management systems (DBMSs) such as MySQL 2 , PostgreSQL, Microsoft Access and SQL Server, DB2, Oracle and SQLite
    RODBC \
    # Implements a 'DBI'-compliant interface to 'MariaDB' (<https://mariadb.org/>) and 'MySQL' (<https://www.mysql.com/>) databases. 
    RMariaDB \
    && rm -rf /tmp/downloaded_packages/

# NLP
RUN install2.r --error \ 
    # Text Mining
    tm \
    # stopword lists
    stopwords \
    # Word Clouds. Functionality to create pretty word clouds, visualize differences and similarity between documents
    wordcloud \
    # A Word Cloud Geom for 'ggplot2'
    ggwordcloud \
    # helps split text into tokens, supporting shingled n-grams, skip n-grams, words, word stems, sentences, paragraphs,
    # characters, lines, and regular expressions. 
    tokenizers \
    # transcript analysis, Text Mining / Natural Language Processing: frequency counts of sentence types, words,
    # sentences, turns of talk, syllables and other assorted analysis tasks
    qdap \
    #approximate string matching version of R's native 'match' function
    stringdist \
    && rm -rf /tmp/downloaded_packages/

# Time series
RUN install2.r --error \ 
    # methods for totally ordered indexed observations
    zoo \
    && rm -rf /tmp/downloaded_packages/

## Install R packages for C++
RUN install2.r --error \
  #Run 'R CMD check' from 'R' programmatically, and capture the results of the individual checks
  rcmdcheck \
  bindr \
  inline \
  rbenchmark \
  RcppArmadillo \
  RUnit \
  highlight \
  && rm -rf /tmp/downloaded_packages/

USER root

RUN mkdir /home/rstudio/rreport
WORKDIR /home/rstudio/rreport

COPY . .


