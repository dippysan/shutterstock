FROM ruby:2.4
MAINTAINER dp@vivitec.com.au

RUN apt-get update && apt-get install -y \
  build-essential

RUN mkdir -p /app
WORKDIR /app

RUN mkdir -p /app/lib/client
COPY Gemfile Gemfile.lock shutterstock.gemspec ./
COPY lib/client/version.rb ./lib/client
RUN gem install bundler && bundle install --jobs 20 --retry 5

ENV RAKE_ENV development

CMD ["bundle", "exec", "rake", "test"]