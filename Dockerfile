# aabor/rreports
# configured for automatic build
FROM rocker/tidyverse:3.6.1

LABEL maintainer="A. A. Borochkin"

RUN apt-get update && apt-get install -y\
  vim \
  && apt-get clean    

# System utilities
RUN install2.r --error \
  doParallel \
  jsonlite \
  # Pure R implementation of the ubiquitous log4j package. It offers hierarchic loggers, multiple handlers per logger,
  # level based filtering, space handling in messages and custom formatting.
  logging \
  && rm -rf /tmp/downloaded_packages/

#Additional ggplot packages
RUN install2.r --error \
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

# Time series
RUN install2.r --error \ 
    # methods for totally ordered indexed observations
    zoo \
    && rm -rf /tmp/downloaded_packages/

# A Utility to Send Emails from R
# https://medium.com/@randerson112358/send-email-using-r-program-1b094208cf2f
# to fix error Sending the email to the following server failed : smtp.gmail.com:465
# accounts with 2-Step Verification enabled. Such accounts require an application-specific password for less secure apps acces
RUN R -e "devtools::install_github('rpremraj/mailR')"

RUN install2.r --error \ 
    # JUnit tests
    testthat \
    && rm -rf /tmp/downloaded_packages/



