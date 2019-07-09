FROM alpine:3.10.0
 
LABEL maintainer="xsystems.org"

ENV LDAP_CONFIG_DIRECTORY="/etc/openldap/slapd.d" \
    LDAP_CONFIG_FILE="/etc/openldap/slapd.conf"

RUN apk add --no-cache  openldap \
                        openldap-back-mdb \
                        openldap-overlay-memberof \
 && mkdir --parents ${LDAP_CONFIG_DIRECTORY} \
 && chown ldap:ldap ${LDAP_CONFIG_DIRECTORY} \
 && chown ldap:ldap /var/lib/openldap/openldap-data

COPY start.sh /etc/openldap/

ENTRYPOINT ["sh", "-c"]
CMD ["/etc/openldap/start.sh -d any -f ${LDAP_CONFIG_FILE} -F ${LDAP_CONFIG_DIRECTORY}"]

EXPOSE 389
