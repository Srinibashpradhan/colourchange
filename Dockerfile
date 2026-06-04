# Use the lightweight, open-source stable Nginx image
FROM nginx:alpine

# Copy your local index.html file into the Nginx web server directory
COPY index.html /usr/share/nginx/html/

# Expose port 80 to web traffic
EXPOSE 80
