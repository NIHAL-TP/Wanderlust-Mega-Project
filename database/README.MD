# Run the commands to initiate redis and mongodb

docker run -d --name mongo -p 27017:27017 -v mongo-data:/data/db mongo:latest
docker run -d --name redis -p 6379:6379 -v redis-data:/data redis:latest