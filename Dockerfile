FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -qq libz-dev

WORKDIR /course_app

COPY . /course_app/

RUN gem update bundler && bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["bundle", "exec", "puma"]