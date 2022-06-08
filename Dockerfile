###############################################################################################
# HCSS shinyapp - BASE
###############################################################################################
FROM rocker/r-ubuntu:20.04 as hcss-shinyapp-base

RUN mkdir /srv/app

# install general debugging tools
RUN apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update
RUN apt-get upgrade -y
RUN apt-get install vim -y
RUN apt-get install net-tools -y
RUN apt-get install dos2unix -y

ENV R_HOME /usr/lib/R

RUN apt-get install software-properties-common -y

RUN add-apt-repository ppa:ubuntugis/ppa -y

# system libraries
RUN apt-get update && apt-get install -y \
    w3m \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.1 \
    default-jdk \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libssl-dev

###############################################################################################
# HCSS shinyapp - PRODUCTION
###############################################################################################
FROM hcss-shinyapp-base as hcss-shinyapp-deploy

# R packages
RUN R -e "install.packages(c('shinyBS', \
                            'tidytext', \
                            'shiny', \
                            'shinyWidgets', \
                            'RJDBC', \
                            'leaflet', \
                            'shinycssloaders', \
                            'tidyverse', \
                            'RColorBrewer', \
                            'DT', \
                            'readxl', \
                            'ggmap', \
                            'countrycode', \
                            'sf', \
                            'data.table', \
                            'plotly', \
                            'flexdashboard', \
                            'devtools', \
                            'timevis', \
                            'leaflet.extras', \
                            'shinydashboard', \
                            'tm', \
                            'wordcloud2', \
                            'rsconnect', \
                            'shinyjs', \
                            'maps', \
                            'd3heatmap', \
                            'xts', \
                            'zoo', \
                            'rgdal', \
                            'radarchart', \
                            'separationplot', \
                            'glue', \
                            'maptools', \
                            'geosphere', \
                            'igraph', \
                            'ggrepel', \
                            'ggthemes', \
                            'treemap', \
                            'ggraph', \
                            'rjson', \
                            'comtradr', \
                            'readr', \
                            'rworldmap', \
                            'gsheet', \
                            'crosstalk', \
                            'heatmaply', \
                            'prettydoc', \
                            'qdap', \
                            'pheatmap'), repos='https://cloud.r-project.org/')"

RUN R -e "devtools::install_github('dkahle/ggmap', ref = 'tidyup')"
RUN R -e "remotes::install_github('rstudio/DT')"
RUN R -e "devtools::install_github('nik01010/dashboardthemes')"
RUN R -e "devtools::install_github('datastorm-open/visNetwork')"
RUN R -e "devtools::install_github('mattflor/chorddiag')"
RUN R -e "devtools::install_github('dgrtwo/widyr')"
RUN R -e "devtools::install_github('jbryer/DTedit')"
RUN R -e "remotes::install_github('rstudio/rmarkdown')"
RUN R -e "devtools::install_github('talgalili/d3heatmap')"
RUN R -e "update.packages(ask = FALSE)"

COPY docker/Rprofile.site /usr/lib/R/etc/
RUN dos2unix /usr/lib/R/etc/Rprofile.site

EXPOSE 3838

RUN ulimit -s unlimited

CMD ["R", "-e", "shiny::runApp('/srv/app/app.R')"]
