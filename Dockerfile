FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y nodejs libz-dev && apt-get install npm -y && npm install -g yarn

WORKDIR /course_app

COPY . /course_app/

RUN gem update bundler && bundle install

RUN yarn install

RUN rails assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
