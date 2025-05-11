# Use the official Flutter image with web support
FROM cirrusci/flutter:latest

# Enable web support (in case it's not enabled)
RUN flutter channel stable
RUN flutter upgrade
RUN flutter config --enable-web

# Copy project files
WORKDIR /app
COPY . .

# Build the Flutter web project
RUN flutter pub get
RUN flutter build web

# Use a simple web server to serve the content
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html
