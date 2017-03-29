FROM alpine:3.5

RUN apk add --update nodejs git
RUN git clone https://github.com/groupon/greenscreen.git /greenscreen

WORKDIR /greenscreen
RUN npm install
EXPOSE 4994

ADD greenscreen.sh /greenscreen

CMD ["sh", "/greenscreen/greenscreen.sh"]