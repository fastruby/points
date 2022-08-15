FROM circleci/ruby:3.0.2-node-browsers

ARG BUNDLE_GEMFILE=Gemfile

WORKDIR /code

# Uncomment this line if docker return any permission errors when trying to
# run commands for building or running the image.
# USER root

COPY Gemfile* ./

RUN gem install bundler:"$(tail -n 1 Gemfile.lock)"
RUN BUNDLE_GEMFILE=${BUNDLE_GEMFILE} bundle "_$(tail -n 1 Gemfile.lock)_" install

EXPOSE 3000

