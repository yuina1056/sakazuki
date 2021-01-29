FROM node:12.20.1-alpine as node

FROM ruby:2.7.2-alpine as builder
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# install dependent package
RUN apk --update --no-cache add \
    shadow=~4.8 sudo=~1.9 busybox-suid=~1.32 mariadb-connector-c-dev=~3.1 \
    tzdata=~2021 alpine-sdk=~1.0 postgresql-client=~13.1 postgresql-dev=~13.1

WORKDIR /rails

COPY Gemfile Gemfile.lock ./

# webpacker environment
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/include/node /usr/local/include/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /opt/yarn-v1.22.5 /opt/yarn
RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
    ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn

# bundle installした後、makeで発生した不要なファイルは削除。
RUN gem install bundler --version 2.2.7 && \
    # bundle install --without development test --path vendor/bundle && \
    bundle install --path vendor/bundle && \
    # find vendor/bundle/ruby -path '*/gems/*/ext/*/Makefile' -exec dirname {} \; | \
    # xargs --max-args=1 --max-procs=4 -I{} make -C {} clean
    find vendor/bundle/ruby -path '*/gems/*/ext/*/Makefile' | \
    xargs -n1 dirname | \
    xargs -n1 -P4 -I{} make -C {} clean

# yarn install
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean

# assets precompile
COPY app/javascript app/javascript
COPY app/assets app/assets
COPY bin bin
COPY config config
COPY app/models app/models
# COPY Rakefile Rakefile
# COPY tsconfig.json tsconfig.json
COPY Rakefile tsconfig.json ./
# RUN RAILS_ENV=production bundle exec rails assets:precompile
RUN RAILS_ENV=development bundle exec rails assets:precompile

FROM ruby:2.7.2-alpine

# パッケージ全体を軽量化して、railsが起動する最低限のものにする
RUN apk --update --no-cache add \
    shadow=~4.8 sudo=~1.9 busybox-suid=~1.32 mariadb-connector-c-dev=~3.1 \
    tzdata=~2021 execline=~2.7 postgresql-client=~13.1 && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
    # apk del --purge tzdata

WORKDIR /sakazuki

# gemやassets:precompileの終わったファイルはbuilderからコピーしてくる
COPY --from=builder /rails/vendor/bundle vendor/bundle
COPY --from=builder /usr/local/bundle /usr/local/bundle

COPY --from=builder /rails/public/assets/ /sakazuki/public/assets/
COPY --from=builder /rails/public/packs/ /sakazuki/public/packs/
# COPY --from=builder /rails/node_modules /sakazuki/node_modules

COPY . /sakazuki

# COPY app /sakazuki/app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
