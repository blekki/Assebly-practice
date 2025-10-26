## Docker-related

### 1. install docker

```shell
open https://www.docker.com
```

### 2. go to folder with image definition

```shell
cd dev-env
```

### 3. build docker image

```shell
docker compose build
```

as a result we will have image named `dev-env-asm32`

### 4. docker look for image built

```shell
docker image ls
```

```terminaloutput
dev-env-asm32         latest     feac1f563065   3 weeks ago     514MB
```

### 5. start container

```shell
docker compose up -d
```

```terminaloutput
 ✔ Network dev-env_default    Created                                                                                                                                      0.0s 
 ✔ Container dev-env-asm32-1  Started                                                                                                                                      0.1s 
```

### 6. check if container running

```shell
docker ps
```

```terminaloutput
CONTAINER ID   IMAGE             COMMAND            CREATED          STATUS          PORTS     NAMES
4156caae1a1e   dev-env-asm32     "sleep infinity"   22 seconds ago   Up 21 seconds             dev-env-asm32-1
```

### 7. jump into docker container

```shell
docker exec -ti dev-env-asm32-1 zsh
```

## compile-related

### 8.1. create/edit your asm file in your favorite editor

### 8.2. go to corresponding folder in the linux VM

```shell
cd lessons/1
```

### 8.3. compile

```shell
nasm -f elf32 hello-world.asm -o hello-world.o
```
file `hello-world.o` should be created

```shell
ls -la
```

```terminaloutput
drwxr-xr-x 4 root root 128 Sep  8 09:31 .
drwxr-xr-x 3 root root  96 Sep  8 09:14 ..
-rw-r--r-- 1 root root 407 Sep  8 09:31 hello-world.asm
-rw-r--r-- 1 root root 640 Sep  8 09:31 hello-world.o
```
### 8.4. link (make executable)

```shell
ld -m elf_i386 hello-world.o -o hello-world
```
runnable file `hello-world` should be created
```shell
ls -la
```
```terminaloutput
-rwxr-xr-x 1 root root 8672 Sep  8 09:33 hello-world
-rw-r--r-- 1 root root  407 Sep  8 09:31 hello-world.asm
-rw-r--r-- 1 root root  640 Sep  8 09:31 hello-world.o
```

### 8.5. run !

```shell
./hello-world
```

```terminaloutput
Hello from Assembly!
```

### 8.6. repeat, experiment, do more, enjoy

## Docker-related

### 9. exit from container (when you finish your work)
```shell
exit
```

### 10. stop container after work (when you want to turn off your computer)
```shell
docker stop dev-env-asm32-1
```

### 11. remove unused docker container (in the end of the course)
```shell
docker image rm dev-env-asm32 --force
```

## Compile specific projects
The reposetory contains a couple specific projects that work with include **(.inc)** files. To compile them use one of the prepared commands in the **./homework** folder ```cd ./homework```, makefile does all the work.

#### List of specific projects
* ```hw4-1```
* ```hw4-2```
* ```hw5```

### Preparation

Before build them need to prepare the ```.inc``` files. Next command does it. You can make it only one time and forget about it.
```shell
    make preparation
```

### Build

After that, build the project with a followed command by replacing ```"project_name"``` with the desired file.
```shell
    make compile-plus main=project_name
```

### Run

And after just **run** the execution file:
```shell
    ./run
```

## PS:
Good luck :)