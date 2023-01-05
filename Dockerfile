#1 Từ base image
FROM node
WORKDIR /app

#2 Coppy toàn bộ source
COPY . .

#3 install dependence
RUN npm i

# build code
RUN npm run build

# run app
CMD [ "npm", "run", "start" ]