# syntax=docker/dockerfile:1
FROM ruby:2.6.3
RUN echo "deb http://deb.debian.org/debian/ unstable main contrib non-free" >> /etc/apt/sources.list.d/debian.list
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client firefox xvfb
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.next /app/Gemfile.next
COPY Gemfile.next.lock /app/Gemfile.next.lock
RUN bundle install
RUN BUNDLE_GEMFILE=Gemfile.next bundle install

# Add a script to be executed every time the container starts.
COPY bin/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
