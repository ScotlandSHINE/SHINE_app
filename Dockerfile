FROM rocker/shiny-verse

ENV run_number=1

RUN R -e "install.packages(c('bslib', 'sass', 'zeallot', 'plotly', 'ggrepel', 'scales', 'shinyjs'))"

COPY app /srv/shiny-server/

COPY shiny-server-files/shiny-server.conf /etc/shiny-server/

RUN chmod 777 -R /srv/shiny-server/

RUN R -e 'sass::sass( \
  sass::sass_file("/srv/shiny-server/styles/shine_app.scss"), \
  output = "/srv/shiny-server/www/shine_app.css")'

RUN echo "This is run number ${run_number}"

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]

ENTRYPOINT echo "run_number='${run_number}'" >> /etc/environment && /usr/bin/shiny-server
