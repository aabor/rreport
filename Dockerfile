# aabor/rstudio
# configured for automatic build
FROM rocker/tidyverse:3.5.3

LABEL maintainer="A. Borochkin"

# System utilities
RUN install2.r --error \
  doParallel \
  jsonlite \
  && rm -rf /tmp/downloaded_packages/

# Java 8
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ## for rJava
    default-jdk \
    ## used to build rJava and other packages
    libbz2-dev \
    libicu-dev \
    liblzma-dev \
    && apt-get clean
RUN install2.r --error \ 
    # Low-level interface to Java VM
    rJava \
    # conversion to and from data in Javascript object notation (JSON) format
    RJSONIO \
    && rm -rf /tmp/downloaded_packages/

#Additional ggplot packages
RUN install2.r --error \
    # Provides text and label geoms for 'ggplot2' that help to avoid overlapping text labels. Labels repel away from
    # each other and away from the data points
    ggrepel \
    # parses and converts LaTeX math formulas to R’s plotmath expressions.
    latex2exp \
    RColorBrewer \
    # wesanderson color palette for R
    wesanderson \
    # Convert Plot to 'grob' or 'ggplot' Object.
    ggplotify \
    # makes it easy to combine multiple 'ggplot2' plots into one and label them with letters, provides a streamlined and clean theme that is used in the Wilke lab
    cowplot \
    # Visualization techniques, data sets, summary and inference procedures aimed particularly at categorical data. Special emphasis is given to highly extensible grid graphics.
    vcd \
    && rm -rf /tmp/downloaded_packages/

# Logging
RUN install2.r --error \ 
    # Pure R implementation of the ubiquitous log4j package. It offers hierarchic loggers, multiple handlers per logger,
    # level based filtering, space handling in messages and custom formatting.
    logging \
    && rm -rf /tmp/downloaded_packages/

# connection to Excel
RUN install2.r --error \ 
    # Simplifies the creation of Excel .xlsx files by providing a high level interface to writing, styling and editing
    # worksheets. Through the use of 'Rcpp', read/write times are comparable to the 'xlsx' and 'XLConnect' packages with
    # the added benefit of removing the dependency on Java.
    openxlsx \
    # Provides comprehensive functionality to read, write and format Excel data. Java dependent.
    XLConnect \
    && rm -rf /tmp/downloaded_packages/
# Tidyverse like packages
RUN install2.r --error \
  # Provides a general-purpose tool for dynamic report generation in R using Literate Programming techniques
  knitr \
  # Construct Complex Table with 'kable' and Pipe Syntax
  kableExtra \
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
    && rm -rf /tmp/downloaded_packages/


# NLP
RUN install2.r --error \ 
    # Text Mining
    tm \
    # stopword lists
    stopwords \
    wordcloud \
    # helps split text into tokens, supporting shingled n-grams, skip n-grams, words, word stems, sentences, paragraphs,
    # characters, lines, and regular expressions. 
    tokenizers \
        # transcript analysis, Text Mining/ Natural Language Processing: frequency counts of sentence types, words,
    # sentences, turns of talk, syllables and other assorted analysis tasks
    qdap \
    #approximate string matching version of R's native 'match' function
    stringdist \
    && rm -rf /tmp/downloaded_packages/


# Latex support
RUN apt-get install -y xzdec \
  texlive-base \
  && apt-get clean

USER root

RUN cd && mkdir texmf \
  && tlmgr init-usertree \ 
  && tlmgr option repository http://mirrors.rit.edu/CTAN/systems/texlive/tlnet \
  && tlmgr update --self \
  && apt-get clean

RUN tlmgr install \
    # most of the functionality of table packages
    tabu \
    # professional-looking layout
    booktabs \
    # typesets tables with captions and notes matching width
    threeparttable \
    # provides the functionality of threeparttable to tables created using longtable
    threeparttablex \
    # lets tabular material span multiple rows
    multirow \
    floatrow \
    ctable 

USER rstudio


