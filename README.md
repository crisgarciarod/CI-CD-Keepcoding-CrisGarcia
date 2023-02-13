# PRÁCTICA FINAL DE CICD :bell:

El objetivo de la práctica es montar un proyecto como cualquiera de los que nos piden en la empresa a los profesionales DevOps.

En este caso, la empresa ACME quiere empezar a probar la nube, por lo que vamos a crear de manera totalmente automatizada unidades de almacenamiento en la nube (AWS S3).

## Requisitos Previos :ballot_box_with_check:

- Cuenta de AWS
- Terraform
- AWS Cli
- IAM user
- Cuenta de GitHub
- Jenkins
- Docker
- Docker-compose

## Clonado del repositorio :notebook_with_decorative_cover:

Para el clonado del repositorio solo es necesario realizarlo de la siguiente manera:

- git clone git@github.com:KeepCodingCloudDevops6/cicd-Crisgarcia.git o bien,
- git clone https://github.com/KeepCodingCloudDevops6/cicd-Crisgarcia.git

## Contenido del repositorio :floppy_disk:

- Una carpeta llamada `terraform`

- Un archivo llamado `makefile`

- Una carpeta llamada `Jenkins`

- Una carpeta llamada `.github/workflows`


A continuación, se especificará el contenido de cada carpeta y de cada archivo.

## Terraform :closed_book:

:warning: :warning: :warning: IMPORTANTE :bangbang:

`Para poder realizar sin problemas esta práctica, se ha tenido que crear un bucket S3 en AWS llamado "bucket-acme-tfstate" para poder guardar el estado de Terraform, para que cualquier persona que tenga acceso a este repositorio pueda trabajar sin problemas. Cabe destacar, que es necesario crear un bucket para el estado que contenga en su nombre "tfstate".`

La empresa para la que estamos trabajando, nos pide que generemos una unidad de almacenamiento, será un bucket S3 de AWS.

Para ello necesitaremos tener instalado `Terraform`, si no lo tuviéramos, lo instalaríamos a través del siguiente link: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli


Para poder ejecutar el despliegue se deben de seguir los siguientes pasos:

 Debemos abrir nuestra terminal y posicionarnos en la carpeta de terraform, dentro de la carpeta deberemos ejecutar los siguientes comandos para desplegar los dos entornos que tenemos preparados:

Para inicializar la configuración de Terraform en el entorno de `desarrollo`:

    terraform init -backend-config=./dev/dev.tfbackend -reconfigure

Y para el entorno de `producción`:

    terraform init -backend-config=./pro/pro.tfbackend -reconfigure

Para crear el plan de ejecución en el entorno de `desarrollo`:

    terraform plan -var-file=dev/dev.tfvars

Y para el entorno de `producción`:

    terraform plan -var-file=pro/pro.tfvars

Para aplicar los cambios necesarios para alcanzar el estado deseado de la configuración, o el conjunto predefinido de acciones generado por un plan ejecución en el entorno de `desarrollo`:

    terraform apply -var-file=dev/dev.tfvars --auto-approve

 Y para el entorno de `producción`:

    terraform apply -var-file=pro/pro.tfvars --auto-approve


En este momento, en nuestra cuenta de AWS que tendríamos que tener generada con anterioridad, nos habrá creado un `bucket s3`.

 Para destruir toda la configuración que hemos generado en el entorno de `desarrollo`:

    terraform destroy -var-file=dev/dev.tfvars --auto-approve

Y para el entorno de `producción:

    terraform destroy -var-file=pro/pro.tfvars --auto-approve

## Makefile :green_book:

La empresa también nos pide, que los desarrolladores puedan hacer el despliegue desde sus máquinas.

Para ello necesitaremos tener instalado `make`, suele venir instalado en nuestra máquina, pero si no lo tuviéramos, lo instalaríamos a través del siguiente link: https://www.geeksforgeeks.org/how-to-install-make-on-ubuntu/

Para poder ejecutar el despliegue se deben de seguir los siguientes pasos:

- Debemos abrir nuestra terminal y posicionarnos en la carpeta raíz y ejecutar los siguientes comandos:


- Para poder hacer un deploy:

        cd terraform/ && terraform init -backend-config=./dev/dev.tfbackend -reconfigure && terraform plan -var-file=./dev/dev.tfvars && terraform apply -var-file=./dev/dev.tfvars -auto-approve

En este momento, en nuestra cuenta de AWS que tendríamos que tener creada con anterioridad, nos habrá creado un `bucket s3`.

- Para poder hacer un destroy: 

        cd terraform/ && terraform init -backend-config=./dev/dev.tfbackend -reconfigure && terraform destroy -auto-approve

- Y para poder ejecutar el deploy y el destroy a la vez, simplemente debemos ejecutar:

        make all

## Jenkins :card_index_dividers:


En este paso, tendremos que tener creado un `Jenkins` en el que podamos ejecutar todo lo que nos pide la empresa ACME.

Si no lo tenemos creado, lo podríamos hacer clonando el siguiente repositorio y siguiendo sus pasos:

`git@github.com:arcones/kc-devops-6-cicd-jenkins-system.git`

New item ➢ Aquí configuraremos el nombre del item y lo crearemos en Multibranch Pipeline por si queremos probar las cosas en el entorno de `desarrollo` o en el de `producción`.

En la siguiente pantalla tendremos que configurar los siguientes puntos:

- Branch Sources ➢ Git
- Project Repository ➢ Aquí deberemos pegar el SSH de nuestro repositorio donde tengamos guardados los archivos
- Credential ➢ Aqui deberemos seleccionar las credenciales :lock: que hemos tenido que configurar para que se pueda conectar con Github.
- Build Configuration:
    - Mode ➢ by Jenkinsfile
    - Script Path ➢ jenkins/cicd.Jenkinsfile

- Save

Con eso ya deberiamos de tener el job creado.

Para que pueda crear el bucket s3 con terraform a través de terraform, tendremos que crear los agentes:

Lo primero que tendremos que hacer es meternos en nuestra terminal, en nuestra carpeta llamada jenkins y en la carpeta agent, crear la imagen llamada `terraform.Dockerfile` para subirla a dockerhub :whale:.

Cuando ya la tengamos creada y subida, hacemos lo siguiente en Jenkins:

 - Manage Jenkins ➢ Manage Nodes and Clouds ➢ Configure Clouds ➢ Docker Agent templates

 Aquí deberemos configurar el agente de terraform.

 Cuando lo tengamos configurado, nos iremos a nuestro `cicd.Jenkinsfile `en nuestra terminal y especificaremos el agente de terraform.

 Con todo esto, ya deberíamos ir a nuestro Jenkins para ejecutar el `Build now` y que nuestro Jenkins nos genere el bucket en AWS.

Para que nos lo borre, tendremos que generar otro job y configurarlo para que coja el `destroy.Jenkinsfile`.

También la empresa ACME quiere revisar cada 10 minutos :hourglass: que el contenido que hay en la unidad de almacenamiento no supero los 20 MiB. Si esto pasa, se vaciará de manera automatizada.

Por lo tanto, crearemos otro job en Jenkins de la misma forma, pero tendremos que hacer un agente de aws con la imagen de `aws.Dockerfile` y configurarla con el `storage.Jenkinsfile`.

## Github Actions :desktop_computer:

Por último, ACME lleva usando Jenkins mucho tiempo pero está actualmente abriéndose a probar nuevas tecnologías con menos coste como Github Actions. Es por esto que también se requiere un pipeline de Github Actions para el despliegue de la unidad de almacenamiento, de modo que ACME pueda comparar ambas tecnologías.

El pipeline se encuentra dentro de la carpeta de .github/workflows, en un archivo llamado main.yml.

Simplemente, tendrían que subir este archivo a su cuenta de github y se ejecutaría solo, para poder verlo, deberán meterse en su github en la pestaña `Actions`.

- Puede tener tres estados:

    - Cuando aparezca este símbolo :green_circle:, querrá decir que se ha ejecutado correctamente y tendríamos que tener levantado el bucket en nuestra cuenta de AWS.

    - Este símbolo :orange_circle:, significa que aún esta ejecutando el archivo main.yml y tendremos que esperar a que acabe.

    - Por último, cuando aparezca el símbolo :red_circle:, significa que algo está mal y, por lo tanto, no se habrá creado el bucket en AWS. (Aquí tendríamos que investigar el porqué está dando errores).


:woman: Cristina Garcia Rodriguez 

:incoming_envelope: crisgarciarodriguez04@gmail.com















    
















