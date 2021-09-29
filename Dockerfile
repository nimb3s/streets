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

#build target to run component tests
FROM publish AS componenttestrunner
WORKDIR /app/tests/Nimb3s.Streets.Api.ComponentTests
RUN dotnet test --logger trx

#build target to run e2e tests
FROM mcr.microsoft.com/playwright:v1.10.0-bionic AS e2etestrunner
COPY --from=publish . .
WORKDIR /app/tests/Nimb3s.Streets.Api.E2ETests
RUN npm i playwright
RUN dotnet test --logger trx

####run api
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS final
WORKDIR /app
COPY --from=publish /app/publish/Nimb3s.Streets.Api /app/executables/Nimb3s.Streets.Api
ENTRYPOINT ["dotnet", "executables/Nimb3s.Streets.Api/Nimb3s.Streets.Api.dll"]

#https://joehonour.medium.com/a-guide-to-setting-up-a-net-core-project-using-docker-with-integrated-unit-and-component-tests-a326ca5a0284