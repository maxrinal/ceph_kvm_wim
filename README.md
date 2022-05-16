# CEPH KVM WIM


Ceph kvm wim nos permite desplegar un pequeño cluster de ceph multi-monitor, multi-osd basado en modulos personalizado de kvm y terraform.


Obtencion de módulos
```bash 
# Por default asumimos que tenemos los modulos en el siguiente directorio, caso contrario debemos modificar el directorio en terraform
TF_MODULES_DEST_DIR=/home/repo/tf_modules
TF_MODULES_GIT_REPO=git@github.com:maxrinal/tf_modules.git

sudo mkdir -m 777 -p $TF_MODULES_DEST_DIR

git clone ${TF_MODULES_GIT_REPO} ${TF_MODULES_DEST_DIR} 


```




Creacion de infra estructura

```bash
cd terraform_kvm

# Copiamos plantilla de tfvars y la editamos con los valores que creamos necesario
cp config.auto.tfvars.example config.auto.tfvars
terraform init

terraform validate

# Generamos plan de ejecucion y validamos que sea correcto
terraform plan -out=plan
# Passing inline vars 
# terraform plan -out=plan -var="EXECUTE_ANSIBLE=false"

# Podemos visualizar el plan
terraform show plan

# Ejecutamos el plan 
terraform apply plan

# Destruir la infra
# terraform destroy
```

# EXTRA INFO

## DOCKER REGISTRY CACHE

Se asume disponible una docker-registry cache, para acelerar el despligue
```bash
# Creacion de volume
docker volume create cache-docker-reg

# Despligue docker-registry cache en puerto 4000 del host
docker run -d -p 4000:5000 \
    -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
    --volume cache-docker-reg:/var/lib/registry \
    --restart always \
    --name registry-docker.io registry:2

# Validacion de logs 
docker logs -f registry-docker.io

# Validacion de cache de imagenes descargadas

curl localhost:4000/v2/_catalog | jq 
```


## TERRAFORM PLUGIN CACHE DIR

Para ahorrar espacio en nuestro directorio podremos descargarlos de forma global generando un directorio para esa cache y configurandolo en un archivo **.terraformrc**, el mismo debe ser generado de forma manual caso contrario obtendremos un error.

```bash
mkdir -p $HOME/.terraform.d/plugin-cache
cat <<EOT | tee $HOME/.terraformrc
plugin_cache_dir   = "\$HOME/.terraform.d/plugin-cache"
EOT
```
