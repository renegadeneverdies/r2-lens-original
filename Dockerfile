FROM ruby:3.2-alpine

RUN apk add --no-cache build-base git tzdata bash curl && rm -rf /var/cache/apk/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

COPY . .

RUN mkdir -p /app/data
