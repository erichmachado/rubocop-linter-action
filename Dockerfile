FROM ruby:2.6.5-alpine

RUN apk add --update build-base git

LABEL "repository"="https://github.com/andrewmcodes/rubocop-linter-action"
LABEL "maintainer"="Andrew Mason <andrewmcodes@protonmail.com>"
LABEL "version"="3.0.0.rc2"

COPY lib /action/lib
COPY README.md LICENSE entrypoint.sh /

RUN gem install bundler

ENTRYPOINT ["/entrypoint.sh"]
