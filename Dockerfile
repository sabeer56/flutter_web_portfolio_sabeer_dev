# Use Debian to install Flutter manually
FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa && \
    apt-get clean

# Set Flutter version and environment variables
ENV FLUTTER_VERSION=3.13.0
ENV FLUTTER_HOME=/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Clone Flutter SDK
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME && \
    cd $FLUTTER_HOME && \
    git checkout $FLUTTER_VERSION

# Pre-download required artifacts for web to avoid tar ownership issues
RUN flutter precache --web

# Enable web support and validate setup
RUN flutter config --enable-web && flutter doctor

# Set project directory
WORKDIR /app
COPY . .

# Get dependencies and build the web project
RUN flutter pub get
RUN flutter build web

# Final stage: Serve using NGINX
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html
