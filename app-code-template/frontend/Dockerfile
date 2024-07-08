# Stage 1: Build stage
FROM node:alpine AS build
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Stage 2: nginx image
FROM nginx:latest
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
