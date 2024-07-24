FROM ruby:3.3.4 AS builder
WORKDIR /srv/jekyll
COPY Gemfile Gemfile.lock ./
ENV BUNDLER_VERSION=2.5.16
RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle install

COPY . .
RUN chown 1000:1000 -R /srv/jekyll
RUN bundle exec jekyll build -d /srv/jekyll/_site

FROM nginx:alpine
COPY --from=builder /srv/jekyll/_site /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]