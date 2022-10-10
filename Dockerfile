FROM ubuntu
RUN apt-get -qq update
RUN apt-get install imagemagick -qq > /dev/null
COPY lb1.sh .
COPY Images/ .
RUN ls
RUN chmod ugo+x lb1.sh
CMD ./lb1.sh
