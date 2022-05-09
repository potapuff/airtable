FROM ruby:3.1.2-alpine
ADD . /mooc
WORKDIR /mooc
RUN apk --no-cache add --virtual .eventmachine-builddeps g++ make \
  && bundle install --without developmnet -j4 \
  && apk del .eventmachine-builddeps
EXPOSE 3000
ENV RACK_ENV=production
CMD bundle exec rackup --host 0.0.0.0 -p 3000
