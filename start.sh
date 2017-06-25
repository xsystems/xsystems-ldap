#!/bin/sh

if [ -n "${LDAP_TLS_ENABLED}" ]; then
  echo "Waiting until key and certificates are available"
  while [ ! -f ${LDAP_TLS_PATH}/cert.pem ]; do
    sleep 1
  done

  echo "TLSCACertificateFile  ${LDAP_TLS_PATH}/chain.pem" >> /etc/openldap/slapd.conf
  echo "TLSCertificateFile    ${LDAP_TLS_PATH}/cert.pem" >> /etc/openldap/slapd.conf
  echo "TLSCertificateKeyFile ${LDAP_TLS_PATH}/privkey.pem" >> /etc/openldap/slapd.conf

  echo "security tls=1" >> /etc/openldap/slapd.conf
fi

for SCHEMA in ${LDAP_SCHEMAS}; do
  echo "include /etc/openldap/schema/${SCHEMA}" >> /etc/openldap/slapd.conf
done

if [ -n "${LDAP_MEMBEROF_ENABLED}" ]; then
 sed -i '/modulepath/a moduleload memberof.so' /etc/openldap/slapd.conf
 echo "overlay memberof" >> /etc/openldap/slapd.conf
 sed -i '/overlay memberof/a memberof-member-ad uniqueMember' /etc/openldap/slapd.conf
 sed -i '/overlay memberof/a memberof-group-oc groupOfUniqueNames' /etc/openldap/slapd.conf
fi

[[ ${LDAP_SUFFIX} ]] && sed -i "/^suffix/c\suffix ${LDAP_SUFFIX}" /etc/openldap/slapd.conf
[[ ${LDAP_ROOTDN} ]] && sed -i "/^rootdn/c\rootdn ${LDAP_ROOTDN}" /etc/openldap/slapd.conf
[[ ${LDAP_ROOTPW} ]] && sed -i "/^rootpw/c\rootpw ${LDAP_ROOTPW}" /etc/openldap/slapd.conf

ulimit -n 1024
exec slapd "$@"
