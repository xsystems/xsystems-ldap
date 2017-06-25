#!/bin/sh

if [ -z "${COMMIT}" ]; then
  echo "The COMMIT environment variable is NOT set, but is required."
fi

if [ -z "${VERSION}" ]; then
  echo "The VERSION environment variable is NOT set, but is required."
fi

git tag --annotate --message "Release ${VERSION}" ${VERSION} ${COMMIT}
git push origin ${VERSION}

docker build --tag xsystems/ldap:${VERSION} "https://github.com/xsystems/xsystems-ldap.git#${COMMIT}"
docker tag xsystems/ldap:${VERSION} xsystems/ldap:latest
docker push xsystems/ldap:${VERSION}
docker push xsystems/ldap:latest
