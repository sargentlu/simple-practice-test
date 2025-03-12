FROM ruby:3.4.2

RUN apt-get update -y && \
    apt-get -y upgrade && \
    apt-get install -y libarchive-tools zip

RUN gem install bundler

COPY Gemfile Gemfile

RUN bundle install

COPY . .

CMD ["bundle", "exec", "rspec", "-fd", "/spec/tests/user_spec.rb:39"]
