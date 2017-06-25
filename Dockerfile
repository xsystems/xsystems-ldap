FROM alpine:3.5

MAINTAINER xsystems

RUN apk add --no-cache openldap \
 && mkdir -p /usr/local/etc/openldap/slapd.d \
 && chown ldap:ldap /usr/local/etc/openldap/slapd.d \
 && chown ldap:ldap /var/lib/openldap/openldap-data

COPY start.sh /etc/openldap/

ENTRYPOINT ["sh", "-c"]
CMD ["/etc/openldap/start.sh -d 32768 -f /etc/openldap/slapd.conf -F /usr/local/etc/openldap/slapd.d"]

EXPOSE 389
