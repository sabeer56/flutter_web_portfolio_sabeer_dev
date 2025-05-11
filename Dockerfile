# Use an official Dart image first, then manually install Flutter 3.5.1
FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa && \
    apt-get clean

# Set Flutter version
ENV FLUTTER_VERSION=3.5.1
ENV FLUTTER_HOME=/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Clone the specific Flutter version
RUN git clone https://github.com/flutter/flutter.git -b $FLUTTER_VERSION $FLUTTER_HOME

# Enable web support
RUN flutter doctor && flutter config --enable-web

# Set project directory
WORKDIR /app
COPY . .

# Get dependencies and build
RUN flutter pub get
RUN flutter build web

# Serve with NGINX
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html
