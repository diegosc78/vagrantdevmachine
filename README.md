# VAGRANT DEV MACHINE

Máquinas vagrant útiles para entornos de desarrollo

## Pre-requisitos

- Tener instalado vagrant (>= 2.3.4) y virtualbox (>=7.0) en la máquina anfitriona

```bash
sudo apt-get install vagrant virtualbox virtualbox-guest-additions-iso
vagrant --version
virtualbox --help
```

## Ciclo de vida

Desde la subcarpeta...

### Configurar

Revisar Vagrantfile (memoria, cpus, ...)

### Levantar

```bash
vagrant up
```

Después reiniciar y comprobar si se redimensiona bien la pantalla; si no, instalar las guest additions manualmente

### Destruir

```bash
vagrant destroy
```

## Re-ejecutar los scripts

```bash
vagrant provision
```


## Máquinas disponibles

### lubuntu-empty-2024

Un lubuntu básico en español y con algunas herramientas.

* Base: ubuntu/jammy64 (22.04 LTS)
* GUI: Sí, Lubuntu 


### lubuntu-javade-2019

Ya no mantenido. Usar bajo tu responsabilidad

### lubuntu-jenkins-docker-2018

Ya no mantenido. Usar bajo tu responsabilidad
