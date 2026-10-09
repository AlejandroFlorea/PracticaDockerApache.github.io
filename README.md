# Documentación de Pasos Realizados: Práctica Docker y Apache

Este documento detalla la secuencia completa de comandos, archivos de configuración y verificaciones realizadas durante el despliegue del servidor web Apache sobre Docker.

---

## 1. Descargar imagen oficial de Debian desde Docker Hub
Se descargó la imagen oficial de Debian utilizando el comando `docker pull`.

```bash
docker pull debian:latest
```

![Paso 1: Descarga de la imagen de debian](paso1.png)

---

## 2. Arrancar el contenedor interactivo en modo detached
Se creó e inició el contenedor con el nombre `apache_AlejandroF`, mapeando el puerto `8080` del host al puerto `80` del contenedor.

```bash
docker run -d -it --name apache_AlejandroF -p 8080:80 debian:latest
```

![Paso 2: Arrancar contenedor apache_AlejandroF](paso2.png)

---

## 3. Ejecutar una shell bash en el contenedor
Se accedió a la terminal del contenedor en ejecución mediante `docker exec`.

```bash
docker exec -it apache_AlejandroF bash
```

![Paso 3: Ejecución de bash en el contenedor](paso3.png)

---

## 4. Instalar el paquete Apache2 dentro del contenedor
Una vez dentro del contenedor, se actualizaron los repositorios de paquetes y se instaló `apache2`.

```bash
apt update && apt install -y apache2
```

![Paso 4: Instalación del paquete apache2](paso4.png)

---

## 5. Arrancar el servicio Apache
Se inició el servicio del servidor web Apache internamente.

```bash
service apache2 start
```

![Paso 5: Inicio del servicio apache2](paso5.png)

---

## 6. Comprobar desde el navegador que el servidor web responde
Se accedió a `http://localhost:8080` en el navegador web para verificar la pantalla de bienvenida por defecto de Debian Apache2.

![Paso 6: Comprobación de página por defecto en localhost:8080](paso6.png)

---

## 7. Crear una nueva página HTML personalizada (`alejandrof.html`)
Se generó el archivo `alejandrof.html` en el directorio `/var/www/html/` dentro del contenedor.

```bash
echo "<h1>Pagina de Alejandro Florea</h1>" > /var/www/html/alejandrof.html
```

![Paso 7: Creación del archivo html personalizado](paso7.png)

---

## 8. Acceder a la página personalizada desde el navegador
Se verificó el acceso a la nueva página ingresando a la URL `http://localhost:8080/alejandrof.html`.

![Paso 8: Visualización de alejandrof.html en el navegador](paso8.png)

---

## 9. Instalar y acceder mediante el navegador en línea de comandos `elinks`
Se instaló `elinks` dentro del contenedor y se comprobó el funcionamiento local del sitio web desde la terminal.

```bash
apt install -y elinks
elinks http://localhost/alejandrof.html
```

![Paso 9: Instalación de elinks](paso9.png)
![Paso 10: Visualización del sitio en elinks](paso10.png)

---

## 10. Crear el archivo `Dockerfile` para automatizar el proceso
Se creó el archivo `Dockerfile` en el host para automatizar la creación de la imagen con Apache y la página personalizada.

```dockerfile
FROM debian:latest

RUN apt update && apt install -y apache2 && rm -rf /var/lib/apt/lists/*

RUN echo "<h1>Página de Alejandro Florea</h1>" > /var/www/html/alejandrof.html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
```

![Paso 11: Contenido del Dockerfile](paso11.png)

---

## 11. Crear la imagen a partir del Dockerfile
Se construyó la imagen utilizando el nombre en minúsculas `apache2_alejandrof:v1` para cumplir con las reglas de nombrado de Docker.

```bash
docker build -t apache2_alejandrof:v1 .
```

![Paso 12: Construcción exitosa de la imagen con docker build](paso12.png)

---

## 12. Ejecutar el contenedor desde la nueva imagen
Se desplegó el contenedor `apache_auto` mapeando el puerto `8081` del host.

```bash
docker run -d --name apache_auto -p 8081:80 apache2_alejandrof:v1
```

![Paso 13: Despliegue del contenedor apache_auto](paso13.png)

---

## 13. Copiar un archivo local a un contenedor en ejecución
Se creó un archivo local `local.html` y se copió dentro de la ruta `/var/www/html/` del contenedor en ejecución mediante `docker cp`.

```bash
echo "<h1>Copia con cp en docker en ejecucion de Alejandro Florea</h1>" > local.html
docker cp local.html apache_auto:/var/www/html/
```

![Paso 14: Comando docker cp para transferir archivo](paso14.png)
![Paso 15: Comprobación en navegador de local.html](paso15.png)

---

## 14. Crear carpeta local y archivo `docker-compose.yml` con volumen
Se creó el directorio local `html_local_AlejandroF` con un archivo `index.html` y se configuró el archivo `docker-compose.yml` para mapear dicho volumen.

```bash
mkdir -p html_local_AlejandroF
echo "<h1>Servidor apache con Docker y Volumenes</h1>" > html_local_AlejandroF/index.html
```

### Contenido de `docker-compose.yml`:
```yaml
services:
  web:
    image: apache2_alejandrof:v1
    container_name: docker_apache
    ports:
      - "8082:80"
    volumes:
      - ./html_local_AlejandroF:/var/www/html
```

![Paso 16: Creación del directorio y archivo local para volumen](paso16.png)
![Paso 17: Configuración de docker-compose.yml](paso17.png)

---

## 15. Arrancar el entorno con Docker Compose y comprobación final
Se levantó el servicio definido en Docker Compose y se verificó la respuesta del servidor en el puerto `8082`.

```bash
docker compose up -d
```

![Paso 18: Despliegue con docker compose up y comprobación final en puerto 8082](paso18.png)