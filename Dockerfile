FROM debian:latest

RUN apt update && apt install -y apache2 && rm -rf /var/lib/apt/lists/*

RUN echo "<h1>Página de Alejandro Florea</h1>" > /var/www/html/alejandrof.html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]