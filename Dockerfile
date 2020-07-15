FROM madnight/docker-alpine-wkhtmltopdf:alpine-3.9 as wkhtmltopdf

FROM ruby:2.6.1-alpine3.8
ARG RAILS_ENV
ENV RAILS_ENV=${RAILS_ENV:-development}
RUN echo "Building with RAILS_ENV=${RAILS_ENV}"

WORKDIR /srv/app

RUN apk --update --upgrade --no-cache add curl-dev build-base openssh \
	tzdata libxml2 libxml2-dev libxslt libxslt-dev postgresql-dev graphviz \
    libgcc libstdc++ libx11 glib libxrender libxext libintl \
    libcrypto1.0 libssl1.0 \
    ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family

COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/

COPY Gemfile* /srv/app/
COPY Gemfile.lock* /srv/app/

ARG REBUILD_GEMS
RUN if [ ${RAILS_ENV} = 'production' ]; then bundle install --without test development --jobs 4; else bundle install --jobs 4; fi

COPY . /srv/app/

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]