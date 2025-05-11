# Base image with Flutter and web support
FROM cirrusci/flutter:latest

# Set the working directory
WORKDIR /app

# Copy project files
COPY . .

# Get dependencies
RUN flutter pub get

# Build the Flutter web app
RUN flutter build web

# Use NGINX to serve the web app
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html
