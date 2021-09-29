#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat


####create build layer
#########################################################################################################################
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app
COPY . .
RUN ls -R
RUN dotnet restore 
COPY . .
RUN dotnet build -c Release -o /app/build/Nimb3s.Streets.Api


FROM build AS unittests
WORKDIR /app
RUN dotnet test "tests/Nimb3s.Streets.Api.UnitTests/Nimb3s.Streets.Api.UnitTests.csproj" --logger:trx

FROM unittests AS publish
RUN dotnet publish "src/Nimb3s.Streets.Api/Nimb3s.Streets.Api.csproj" -c Release -o /app/publish/Nimb3s.Streets.Api

# create a new build target called componenttestrunner
FROM publish AS componenttestrunner
WORKDIR /app/tests/Nimb3s.Streets.Api.ComponentTests
# when you run this build target it will run the component tests
CMD ["dotnet", "test", "--logger:trx"]
#CMD dotnet test --verbosity normal

# create a new build target called e2etestrunner
FROM publish as e2etestrunner
#RUN dotnet tool install --global Microsoft.Playwright.CLI
#RUN playwright install
WORKDIR /app/tests/Nimb3s.Streets.Api.E2ETests
RUN dotnet restore
RUN dotnet publish
RUN apt-get update \
    && apt-get install libglib2.0-0 -y \
    && apt-get install libnss3 -y \
    && apt-get install libnspr4 -y \
    && apt-get install libatk1.0-0 -y \
    && apt-get install libatk-bridge2.0-0 -y \
    && apt-get install libcups2 -y \
    && apt-get install libdrm2 -y \
    && apt-get install libdbus-1-3 -y \
    && apt-get install libexpat1 -y \
    && apt-get install libxcb1 -y \
    && apt-get install libxkbcommon0 -y \
    && apt-get install libx11-6 -y \
    && apt-get install libxcomposite1 -y \
    && apt-get install libxdamage1 -y \
    && apt-get install libxext6 -y \
    && apt-get install libxfixes3 -y \
    && apt-get install libxrandr2 -y \
    && apt-get install libgbm1 -y \
    && apt-get install libgtk-3-0 -y \
    && apt-get install libpango-1.0-0 -y \
    && apt-get install libcairo2 -y \
    && apt-get install libasound2 -y \
    && apt-get install libatspi2.0-0 -y \
    && apt-get install libxshmfence1 -y

RUN chmod +rx,o+rx /app/.playwright \
    && chmod +rx,o+rx /app/.playwright/node \
    && chmod +rx,o+rx /app/.playwright/node/linux \
    && chmod +rx,o+rx /app/.playwright/node/linux/playwright.sh
#RUN chown -R `whoami` /app
#RUN chown -R `whoami` /root
#RUN apt-get update \
#    && apt-get upgrade -y \
#    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
#    && apt-get install -y nodejs
#RUN npm -v
#RUN npm ci
#RUN npm install -g npx
#RUN npx playwright install --with-deps
CMD ["dotnet", "test", "--logger:trx"]
#RUN apt-get update \
#    && apt-get upgrade -y \
#    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
#    && apt-get install -y nodejs

#RUN npm i playwright
#RUN npx playwright install
#RUN npx playwright install-deps
#RUN chown -R `whoami` /root/.cache/ms-playwright
#COPY . .
#ENV PLAYWRIGHT_BROWSERS_PATH=/root/.cache/ms-playwright

#WORKDIR /app/tests/Nimb3s.Streets.Api.E2ETests
#when you run this build target it will run the component tests
#CMD ["dotnet", "test", "--logger:trx"]
#CMD dotnet test --verbosity normal

#FROM mcr.microsoft.com/playwright:v1.10.0-focal as e2etestrunner
#WORKDIR /app/tests/Nimb3s.Streets.Api.E2ETests
#RUN chown -R pwuser:pwuser /app
#CMD ["dotnet", "test", "--logger:trx"] 

####run api
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS final
WORKDIR /app
COPY --from=publish /app/publish/Nimb3s.Streets.Api /app/executables/Nimb3s.Streets.Api
ENTRYPOINT ["dotnet", "executables/Nimb3s.Streets.Api/Nimb3s.Streets.Api.dll"]



#docker build -t example-service:latest . 
#docker run --rm -it -p 5000:80 nimb3s/streets 
#docker stop wtf
#https://joehonour.medium.com/a-guide-to-setting-up-a-net-core-project-using-docker-with-integrated-unit-and-component-tests-a326ca5a0284