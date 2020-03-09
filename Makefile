
build:
	docker build -t ibmosquito/aardvark:1.0.0 .

dev: build
	docker run -it --privileged -v `pwd`:/outside ibmosquito/aardvark:1.0.0 /bin/bash

run:
	docker run -d --privileged ibmosquito/aardvark:1.0.0

push:
	docker push ibmosquito/aardvark:1.0.0
