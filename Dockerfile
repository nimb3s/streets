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
FROM mcr.microsoft.com/playwright:v1.10.0-focal as playwright
FROM publish AS e2etestrunner
WORKDIR /app/tests/Nimb3s.Streets.Api.E2ETests
RUN chown -R pwuser:pwuser /app
#when you run this build target it will run the component tests
CMD ["dotnet", "test", "--logger:trx"]
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