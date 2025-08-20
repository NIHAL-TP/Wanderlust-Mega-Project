# How to run locally using docker 
Initiate database and redis
--------------------------------------
docker run -d --name mongo -p 27017:27017 -v mongo-data:/data/db mongo:latest
docker run -d --name redis -p 6379:6379 -v redis-data:/data redis:latest
-------------------------------------------------------------------------

Build and Run frontend
---------------------------
docker build -t nihaltp/frontend-app:v1 .
run "docker images" and get the image id for the specific image version that you built
docker run -it -p 5173:5173 -v frontend-data:/app/data <IMAGE_ID>

Build and run backend
---------------------------
docker build -t nihaltp/frontend-app:v1 .
docker run -it -p 5000:5000 -v backend-data:/app/data -e MONGODB_URI="mongodb://host.docker.internal:27017/mongo" -e REDIS_URL="redis://host.docker.internal:6379" <IMAGE_ID>