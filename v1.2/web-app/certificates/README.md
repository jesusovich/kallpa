# Comando para crear certificado manual:

```
certbot certonly --manual --preferred-challenges dns -d '*.kallpa.xyz' -d 'kallpa.xyz'
```
El comando se usó desde el docker ubuntu-server de la raspberrypi.