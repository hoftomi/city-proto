# Admin web app: Angular build → nginx. Build context: this folder (tron-nelkul/admin).
#   docker build -t tron-admin tron-nelkul/admin
FROM node:24-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . .
RUN npm run build

FROM nginx:1.29-alpine
# The image's entrypoint substitutes ${BACKEND_URL} into the template at start.
ENV BACKEND_URL=http://backend:8080
COPY nginx.conf /etc/nginx/templates/default.conf.template
COPY --from=build /app/dist/admin/browser /usr/share/nginx/html
EXPOSE 80
