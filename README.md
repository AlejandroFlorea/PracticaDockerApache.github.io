# Documentación de Pasos Realizados: Práctica Docker y Apache

Este documento detalla la secuencia completa de comandos, archivos de configuración y verificaciones realizadas durante el despliegue del servidor web Apache sobre Docker.

---

## 1. Descargar imagen oficial de Debian desde Docker Hub
Se descargó la imagen oficial de Debian utilizando el comando `docker pull`.

```bash
docker pull debian:latest
```

<img width="493" height="145" alt="paso1" src="https://github.com/user-attachments/assets/28f74c1e-beb2-4cbd-9e88-e1622e598b23" />


---

## 2. Arrancar el contenedor interactivo en modo detached
Se creó e inició el contenedor con el nombre `apache_AlejandroF`, mapeando el puerto `8080` del host al puerto `80` del contenedor.

```bash
docker run -d -it --name apache_AlejandroF -p 8080:80 debian:latest
```

<img width="960" height="848" alt="paso2" src="https://github.com/user-attachments/assets/67e3a43e-7f36-4893-a992-52ff08cfd677" />


---

## 3. Ejecutar una shell bash en el contenedor
Se accedió a la terminal del contenedor en ejecución mediante `docker exec`.

```bash
docker exec -it apache_AlejandroF bash
```

<img width="531" height="163" alt="paso3" src="https://github.com/user-attachments/assets/f3a019c2-2f7d-4777-9c58-8fec6e2c0838" />


---

## 4. Instalar el paquete Apache2 dentro del contenedor
Una vez dentro del contenedor, se actualizaron los repositorios de paquetes y se instaló `apache2`.

```bash
apt update && apt install -y apache2
```

<img width="531" height="163" alt="paso3" src="https://github.com/user-attachments/assets/b1cca7e0-af9c-45b8-b8ae-ff76f812ed38" />


---

## 5. Arrancar el servicio Apache
Se inició el servicio del servidor web Apache internamente.

```bash
service apache2 start
```

<img width="593" height="82" alt="paso4" src="https://github.com/user-attachments/assets/8fea4a4d-0cb8-4c79-8e78-1b19cfe4e0b1" />


---

## 6. Comprobar desde el navegador que el servidor web responde
Se accedió a `http://localhost:8080` en el navegador web para verificar la pantalla de bienvenida por defecto de Debian Apache2.

<img width="1919" height="998" alt="paso5" src="https://github.com/user-attachments/assets/da6c0384-0040-4ca3-86f0-5e92db4e2453" />


---

## 7. Crear una nueva página HTML personalizada (`alejandrof.html`)
Se generó el archivo `alejandrof.html` en el directorio `/var/www/html/` dentro del contenedor.

```bash
echo "<h1>Pagina de Alejandro Florea</h1>" > /var/www/html/alejandrof.html
```

<img width="538" height="35" alt="paso6" src="https://github.com/user-attachments/assets/ee859cbd-21ce-4896-863f-014c30aef8a9" />


---

## 8. Acceder a la página personalizada desde el navegador
Se verificó el acceso a la nueva página ingresando a la URL `http://localhost:8080/alejandrof.html`.

<img width="566" height="220" alt="paso7" src="https://github.com/user-attachments/assets/c1186cf6-a9d2-4e1a-a622-2fbac1e052d1" />

---

## 9. Instalar y acceder mediante el navegador en línea de comandos `elinks`
Se instaló `elinks` dentro del contenedor y se comprobó el funcionamiento local del sitio web desde la terminal.

```bash
apt install -y elinks
elinks http://localhost/alejandrof.html
```

<img width="373" height="266" alt="paso8" src="https://github.com/user-attachments/assets/3134a612-c5c6-45c0-a600-19a3cf68c412" />

<img width="601" height="286" alt="paso9" src="https://github.com/user-attachments/assets/38a1824c-7297-47f6-a4be-befef1c35254" />

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

<img width="671" height="238" alt="paso10" src="https://github.com/user-attachments/assets/97ed2a7b-cc82-49c5-9e07-54c8e969d16b" />


---

## 11. Crear la imagen a partir del Dockerfile
Se construyó la imagen utilizando el nombre en minúsculas `apache2_alejandrof:v1` para cumplir con las reglas de nombrado de Docker.

```bash
docker build -t apache2_alejandrof:v1 .
```
<img width="863" height="463" alt="paso11" src="https://github.com/user-attachments/assets/c7abb18c-ad88-44e5-aa09-e5f2b2743ffa" />


---

## 12. Ejecutar el contenedor desde la nueva imagen
Se desplegó el contenedor `apache_auto` mapeando el puerto `8081` del host.

```bash
docker run -d --name apache_auto -p 8081:80 apache2_alejandrof:v1
```

<img width="855" height="59" alt="paso12" src="https://github.com/user-attachments/assets/58dcdc8c-332b-4367-b514-f275dd3ddc7d" />


---

## 13. Copiar un archivo local a un contenedor en ejecución
Se creó un archivo local `local.html` y se copió dentro de la ruta `/var/www/html/` del contenedor en ejecución mediante `docker cp`.

```bash
echo "<h1>Copia con cp en docker en ejecucion de Alejandro Florea</h1>" > local.html
docker cp local.html apache_auto:/var/www/html/
```
<img width="856" height="90" alt="paso13" src="https://github.com/user-attachments/assets/7fae8b6a-87a5-4f89-86b5-28daf51219e5" />

<img width="871" height="224" alt="paso14" src="https://github.com/user-attachments/assets/5adbae75-25e7-4874-b4c1-626ad1b061e7" />


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

<img width="854" height="200" alt="paso15" src="https://github.com/user-attachments/assets/52afedd0-a349-40ba-bcf4-6b1d1138a738" />

<img width="367" height="182" alt="paso16" src="https://github.com/user-attachments/assets/c0733c85-5358-4002-b88b-8d5df780dc20" />

---

## 15. Arrancar el entorno con Docker Compose y comprobación final
Se levantó el servicio definido en Docker Compose y se verificó la respuesta del servidor en el puerto `8082`.

```bash
docker compose up -d
```
<img width="854" height="452" alt="paso17" src="https://github.com/user-attachments/assets/1e4d3d3b-a7ab-4a37-87e3-303f941efac9" />

<img width="1283" height="206" alt="paso18" src="https://github.com/user-attachments/assets/ba397ca7-82ff-4a3f-a2fb-fbb4cd559808" />

