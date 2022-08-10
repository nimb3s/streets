#########################
### build app ###
#########################

# base image
FROM node:16.16.0 as build

# set working directory
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /usr/src/app/package.json

# add app
COPY . /usr/src/app
#RUN npm install -g yarn
RUN npm install @angular/cli -g
RUN npm i
RUN ng add @angular-eslint/schematics@next --skip-confirmation
RUN ng lint
RUN npm run build --prod

#########################
###build target to run e2e tests###
#########################
# FROM cypress/browsers:chrome69
# COPY --from=build . .
# ARG PATH_INSTALL=/_cypress
# ENV PATH_INSTALL=${PATH_INSTALL}
# ENV CYPRESS_CACHE_FOLDER=${PATH_INSTALL}/.cache/Cypress
# RUN \
#     mkdir -p ${PATH_INSTALL} && \
#     cd ${PATH_INSTALL} && \
#     npm install cypress --save-dev && \
#     find ${CYPRESS_CACHE_FOLDER} -type d -exec chmod 0777 {} \;
# # Null audio output - when the container runs as a 'non-root' user, it does not have sound permissions
# # https://github.com/cypress-io/cypress-docker-images/issues/52#issuecomment-446144630
# # https://github.com/ValveSoftware/steam-for-linux/issues/2962#issuecomment-28081659
# # https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture/Troubleshooting
# COPY asound.conf /etc/asound.conf
# # To run tests - mount `${PATH_WORKDIR}/cypress.json:ro` and `${PATH_WORKDIR}/cypress:ro`
# ARG PATH_WORKDIR=/cypress
# RUN mkdir -p ${PATH_WORKDIR} && chmod -R 777 ${PATH_WORKDIR}
# WORKDIR /cypress
# ENTRYPOINT HOME=/tmp/ ${PATH_INSTALL}/node_modules/.bin/cypress $0 $@
# CMD run


#stage 2
####run web app
FROM nginx:alpine
COPY --from=build /usr/src/app/dist/host-app /usr/share/nginx/html
# expose port 80
EXPOSE 80
# run nginx
CMD ["nginx", "-g", "daemon off;"]


#FROM cypress/browsers:chrome69
#COPY --from=build /usr/src/app /usr/src/app
#WORKDIR /usr/src/app
#RUN npm install @angular/cli -g
#RUN npm i
#RUN npm run cypress:run

#RUN yarn add cypress --dev


# generate build
#RUN npm run build




##################
### production ###
##################

# base image
#FROM nginx:1.13.9-alpine

# copy artifact build from the 'build environment'
#COPY --from=builder /usr/src/app/dist /usr/share/nginx/html

# expose port 80
#EXPOSE 80

# run nginx
#CMD ["nginx", "-g", "daemon off;"]

#apt-get install libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb
#docker build -t nimb3s/host-app --no-cache --progress plain .
