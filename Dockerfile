FROM rocker/shiny-verse

RUN R -e "install.packages(c('bslib', 'sass', 'zeallot', 'shinyWidgets' , 'plotly', 'ggmosaic', 'ggrepel', 'scales', 'Rcpp'))"

COPY app /srv/shiny-server/

COPY shiny-server-files/shiny-server.conf /etc/shiny-server/

RUN chmod 777 /srv/shiny-server/

RUN R -e 'sass::sass( \
  sass::sass_file("/srv/shiny-server/styles/shine_app.scss"), \
  output = "/srv/shiny-server/www/shine_app.css")'
  
EXPOSE 3838

CMD ["/usr/bin/shiny-server"]