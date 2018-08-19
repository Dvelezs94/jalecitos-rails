FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /jalesitos
WORKDIR /jalesitos
COPY . .
RUN bundle install
RUN rm -f tmp/pids/server.pid
CMD bundle exec rails s -p 3000 -b '0.0.0.0'
