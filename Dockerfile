FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa && \
    apt-get clean

# Override tar to ignore ownership issues
RUN echo -e '#!/bin/sh\nexec /bin/tar --no-same-owner "$@"' > /usr/local/bin/tar && chmod +x /usr/local/bin/tar

# Set Flutter environment
ENV FLUTTER_VERSION=3.13.0
ENV FLUTTER_HOME=/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Clone Flutter SDK
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME && \
    cd $FLUTTER_HOME && \
    git checkout $FLUTTER_VERSION

# Precache web artifacts and enable web
RUN flutter precache --web
RUN flutter config --enable-web && flutter doctor

# Set project directory
WORKDIR /app
COPY . .

# Get dependencies and build
RUN flutter pub get
RUN flutter build web

# Serve with nginx
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html
