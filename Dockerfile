FROM circleci/ruby:3.0.2-node-browsers

WORKDIR /app

# Copy all the Gemfile files
COPY Gemfile* ./

RUN gem install bundler -v "$(tail -n 1 Gemfile.lock)"
RUN bundle install
RUN BUNDLE_GEMFILE=Gemfile.next bundle install

# Add a script to be executed every time the container starts.
COPY bin/entrypoint.sh /usr/bin/
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
