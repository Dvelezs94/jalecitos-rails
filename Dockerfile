FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev curl software-properties-common

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt install -y nodejs

# cleanup
RUN rm -rf /var/lib/apt/lists/*

# Create app user for correct file permissions
ARG US_ID=1000
ARG GR_ID=1000
ARG USERNAME=jalecitos

RUN addgroup --gid $GR_ID $USERNAME
RUN adduser --disabled-password --gecos '' --uid $US_ID --gid $GR_ID $USERNAME

USER $USERNAME

RUN mkdir /home/$USERNAME/app
WORKDIR /home/$USERNAME/app
COPY --chown=$USERNAME . .

RUN bundle install
RUN rm -f tmp/pids/server.pid
CMD bundle exec rails s -p 3000 -b '0.0.0.0'
