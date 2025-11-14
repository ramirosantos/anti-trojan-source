FROM node:20-bookworm-slim

ENV NODE_ENV=production
# TERM for curses UIs
ENV TERM=xterm

# Install CLI and tools; util-linux provides `script` for a pseudo-TTY
RUN npm install -g anti-trojan-source \
  && apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates util-linux \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data

COPY polyfill-unref.js /usr/local/bin/polyfill-unref.js
COPY entrypoint.sh /usr/local/bin/anti-trojan-source-entrypoint
RUN chmod +x /usr/local/bin/anti-trojan-source-entrypoint

ENTRYPOINT ["/usr/local/bin/anti-trojan-source-entrypoint"]
