Assignment 01 Submission
==========

Author: Elliot Schot <S3530160@student.rmit.edu.au>

----------------
##### Container information #####

username: 'mrfishy'
password: 'docker'

----------------
##### To run the container localy do: #####
note: if the github repo is private you need to git clone/pull 

~~~
git clone git@github.com:rmit-s3530160-elliot-schot/COSC1133.git
cd COSC1133/
docker build -t s3530160/assignment .
docker run -d -p 20160:22 -p 50160:80 --name assignment s3530160/assignment
~~~

----------------
##### To run this directly from docker hub do: ##### 

~~~
docker run -d -p 20160:22 -p 50160:80 s3530160/cosc1133-A1
~~~

----------------
##### To finish do: ##### 
~~~
docker stop assignment01
~~~
~~~
docker rm assignment01
~~~

----------------
##### To log into your container do: ##### 

~~~
ssh -x myfishy@localhost -p 20160
~~~

----------------
##### To view running containers: (and to see all current containers) #####
```
docker ps
docker ps -a
```

----------------
##### To close and delete the container: ##### 
```
docker stop assignment
docker rm assignment
```

-----------
