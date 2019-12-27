FROM gists/qbittorrent:4.2.1

RUN \
   apk add --no-cache dumb-init &&\
   # Add non-root user
   adduser -S -D -u 520 -g 520 -s /sbin/nologin qbittorrent && \
   # Create symbolic links to simplify mounting
   mkdir -p /home/qbittorrent/.config/qBittorrent && \
   mkdir -p /home/qbittorrent/.local/share/data/qBittorrent && \
   mkdir /downloads && \
   chmod go+rw -R /home/qbittorrent /downloads && \
   ln -s /home/qbittorrent/.config/qBittorrent /config && \
   ln -s /home/qbittorrent/.local/share/data/qBittorrent /torrents && \
   # Check it works
   su qbittorrent -s /bin/sh -c 'qbittorrent-nox -v'

# Default configuration file.
COPY qBittorrent.conf /default/qBittorrent.conf
COPY entrypoint.sh /

VOLUME ["/config", "/torrents", "/downloads"]

ENV HOME=/home/qbittorrent

USER qbittorrent

EXPOSE 8080 6881

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]
CMD ["qbittorrent-nox"]
