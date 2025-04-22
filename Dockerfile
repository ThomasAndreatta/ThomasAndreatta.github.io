FROM jekyll/jekyll:3.8

WORKDIR /srv/jekyll

RUN apk add --no-cache build-base gcc cmake git

VOLUME /usr/local/bundle

EXPOSE 4001

RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'bundle install' >> /entrypoint.sh && \
    echo 'exec "$@"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4001"]