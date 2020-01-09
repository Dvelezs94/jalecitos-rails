FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    software-properties-common \
    nginx \
    supervisor


# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt install -y nodejs

# Create workspace for app
RUN mkdir /jalecitos
WORKDIR /jalecitos

# Copy source files
COPY . .

# Install gems
RUN bundle install

# Run asset precompile if CI_AGENT key is set
RUN if [ -n "$CI_AGENT" ]; then bundle exec rake assets:precompile; fi

# Copy supervisor config files
COPY .docker/supervisord.conf /etc/supervisor/supervisord.conf
COPY .docker/supervisor-services.conf /etc/supervisor/conf.d/services.conf

# Copy nginx files
RUN rm /etc/nginx/sites-enabled/default
COPY .docker/nginx.conf /etc/nginx/sites-enabled/

# Prevent server pid from saving
RUN rm -f tmp/pids/server.pid

# cleanup
RUN rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/supervisord"]
