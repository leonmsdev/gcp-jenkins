FROM nginx
 
 RUN apt-get update && apt-get upgrade -y
 
 COPY /src/index.html /usr/share/nginx/html/
 
 EXPOSE 8080
 
 CMD ["nginx", "-g", "daemon off;"]