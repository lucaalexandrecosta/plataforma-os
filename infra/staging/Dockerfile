# Imagens do ambiente de testes (infra/staging/compose.yaml). Contexto do build:
# a raiz do repositório. Dois alvos:
#   server  servidor Serverpod compilado (dart build cli) + migrações
#   proxy   Caddy com o backoffice (Flutter Web) e as rotas /api, /arquivos, /mail
#
# O pub workspace inclui os apps Flutter, então o build usa o SDK do Flutter
# (que traz o Dart do servidor), na mesma versão do CI.

ARG FLUTTER_VERSION=3.47.9
ARG DBMATE_VERSION=2.28.0

# ------------------------------------------------------------------- build
FROM ubuntu:24.04 AS build
ARG FLUTTER_VERSION
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git unzip xz-utils \
 && rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 --branch "${FLUTTER_VERSION}" https://github.com/flutter/flutter.git /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}" \
    FLUTTER_SUPPRESS_ANALYTICS=true \
    PUB_CACHE=/opt/pub-cache
RUN flutter config --no-analytics --no-cli-animations >/dev/null \
 && flutter precache --web --no-android --no-ios --no-linux --no-macos --no-windows --no-fuchsia

WORKDIR /src
# Dependências primeiro (camada reaproveitada enquanto os pubspecs não mudam).
COPY pubspec.yaml pubspec.lock ./
COPY apps/backoffice_web/pubspec.yaml apps/backoffice_web/
COPY apps/field_app/pubspec.yaml apps/field_app/
COPY packages/core/pubspec.yaml packages/core/
COPY packages/depreciation/pubspec.yaml packages/depreciation/
COPY server/pubspec.yaml server/
COPY server_client/pubspec.yaml server_client/
RUN flutter pub get --enforce-lockfile

COPY . .
RUN flutter pub get --enforce-lockfile --offline
RUN cd server && dart build cli -t bin/main.dart -o /out/server
# Backoffice e API no mesmo endereço: a API fica em /api/ (ver Caddyfile).
RUN cd apps/backoffice_web \
 && flutter build web --release --no-web-resources-cdn --dart-define=API_URL=/api/ \
 && mv build/web /out/backoffice

# dbmate (migrações do schema "app"), na arquitetura da imagem (amd64 ou arm64).
FROM ubuntu:24.04 AS dbmate
ARG DBMATE_VERSION
ARG TARGETARCH
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl \
 && curl -fsSL -o /usr/local/bin/dbmate \
      "https://github.com/amacneil/dbmate/releases/download/v${DBMATE_VERSION}/dbmate-linux-${TARGETARCH:-amd64}" \
 && chmod +x /usr/local/bin/dbmate

# ------------------------------------------------------------------ server
FROM ubuntu:24.04 AS server
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates openssl postgresql-client tzdata \
 && rm -rf /var/lib/apt/lists/* \
 && useradd --system --home /app --shell /usr/sbin/nologin app \
 && mkdir -p /segredos && chown app /segredos
COPY --from=dbmate /usr/local/bin/dbmate /usr/local/bin/dbmate
WORKDIR /app
COPY --from=build /out/server/bundle/ /app/
COPY server/config/staging.yaml /app/config/staging.yaml
COPY server/migrations /app/migrations
COPY db/migrations /app/db/migrations
COPY db/seeds /app/db/seeds
COPY infra/local/postgres/10-login-roles.sql /app/db/10-login-roles.sql
COPY infra/staging/bootstrap /app/bootstrap
COPY --chmod=755 infra/staging/scripts/ /app/scripts/
# As chaves geradas no primeiro boot ficam no volume /segredos.
RUN ln -s /segredos/passwords.yaml /app/config/passwords.yaml
USER app
ENV TZ=UTC
EXPOSE 8080
ENTRYPOINT ["/app/scripts/server.sh"]

# ------------------------------------------------------------------- proxy
FROM caddy:2.10 AS proxy
COPY infra/staging/Caddyfile /etc/caddy/Caddyfile
COPY --from=build /out/backoffice /srv/backoffice
