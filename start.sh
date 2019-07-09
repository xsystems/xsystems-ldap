#!/bin/sh

if [ -n "${LDAP_TLS_ENABLED}" ]; then
  echo "Waiting until key and certificates are available"
  while [ ! -f ${LDAP_TLS_PATH}/cert.pem ]; do
    sleep 1
  done

  echo "TLSCACertificateFile  ${LDAP_TLS_PATH}/chain.pem"                >> ${LDAP_CONFIG_FILE}
  echo "TLSCertificateFile    ${LDAP_TLS_PATH}/cert.pem"                 >> ${LDAP_CONFIG_FILE}
  echo "TLSCertificateKeyFile ${LDAP_TLS_PATH}/privkey.pem"              >> ${LDAP_CONFIG_FILE}

  echo "security tls=1"                                                  >> ${LDAP_CONFIG_FILE}
fi

for SCHEMA in ${LDAP_SCHEMAS}; do
  echo "include /etc/openldap/schema/${SCHEMA}"                          >> ${LDAP_CONFIG_FILE}
done

if [ -n "${LDAP_MEMBEROF_ENABLED}" ]; then
 sed --in-place '/modulepath/a moduleload memberof.so'                      ${LDAP_CONFIG_FILE}
 sed --in-place '/overlay memberof/a memberof-member-ad uniqueMember'       ${LDAP_CONFIG_FILE}
 sed --in-place '/overlay memberof/a memberof-group-oc groupOfUniqueNames'  ${LDAP_CONFIG_FILE}
 echo "overlay memberof"                                                 >> ${LDAP_CONFIG_FILE}
fi

[ ${LDAP_SUFFIX} ] && sed --in-place "/^suffix/c\suffix ${LDAP_SUFFIX}"     ${LDAP_CONFIG_FILE}
[ ${LDAP_ROOTDN} ] && sed --in-place "/^rootdn/c\rootdn ${LDAP_ROOTDN}"     ${LDAP_CONFIG_FILE}
[ ${LDAP_ROOTPW} ] && sed --in-place "/^rootpw/c\rootpw ${LDAP_ROOTPW}"     ${LDAP_CONFIG_FILE}

ulimit -n 1024
exec slapd "$@"
