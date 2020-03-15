# Dockerfile

# Defines what image to start from.
FROM ruby:2.7
# Download whatever is at this link, even if it has moved, and add it as a trusted APT repository key.
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    # apt-get update: Retrieve newest versions of packages
    # -qq: no output except for errors
    && apt-get update -qq \
    # Install for webpacker
    && apt-get install -y nodejs yarn \
    && mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]