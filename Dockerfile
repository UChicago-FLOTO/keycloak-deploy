FROM quay.io/keycloak/keycloak:22.0 as build

ENV KC_HEALTH_ENABLED=true
ENV KC_HTTP_ENABLED=true
ENV KC_DB=mysql

RUN /opt/keycloak/bin/kc.sh build \
    # This allows backwards compatibility with deprecated redirects.
    # This should eventually be removed, but only after all clients have been migrated
    --spi-login-protocol-openid-connect-legacy-logout-redirect-uri=true

FROM quay.io/keycloak/keycloak:22.0 as release

COPY --from=build /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak

ENV KC_HEALTH_ENABLED=true
ENV KC_HTTP_ENABLED=true
ENV KC_DB=mysql

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]