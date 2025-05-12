# Use the official Flutter image with Dart SDK >= 3.5.1
FROM ghcr.io/cirruslabs/flutter:3.22.0 as build

# Allow Flutter to run as root (important in Docker)
ENV FLUTTER_ALLOW_ROOT=true

# Set working directory
WORKDIR /app

# Copy necessary files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the project
COPY . .

# Build the Flutter web app
RUN flutter build web

# Use a minimal image to serve the built app
FROM nginx:alpine

# Copy the built web assets to nginx's default public folder
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose the web port
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]
