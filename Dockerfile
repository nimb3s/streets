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
COPY ["src/Nimb3s.Streets.Api/Nimb3s.Streets.Api.csproj", "src/Nimb3s.Streets.Api/"]
COPY ["tests/Nimb3s.Streets.Api.UnitTests/Nimb3s.Streets.Api.UnitTests.csproj", "tests/Nimb3s.Streets.Api.UnitTests/"]
COPY ["tests/Nimb3s.Streets.Api.ComponentTests/Nimb3s.Streets.Api.ComponentTests.csproj", "tests/Nimb3s.Streets.Api.ComponentTests/"]
RUN ls -R
RUN dotnet restore "src/Nimb3s.Streets.Api/Nimb3s.Streets.Api.csproj"
RUN dotnet restore "tests/Nimb3s.Streets.Api.UnitTests/Nimb3s.Streets.Api.UnitTests.csproj"
RUN dotnet restore "tests/Nimb3s.Streets.Api.ComponentTests/Nimb3s.Streets.Api.ComponentTests.csproj"
COPY . .
RUN dotnet build "src/Nimb3s.Streets.Api/Nimb3s.Streets.Api.csproj" -c Release -o /app/build/Nimb3s.Streets.Api
RUN dotnet build "tests/Nimb3s.Streets.Api.UnitTests/Nimb3s.Streets.Api.UnitTests.csproj" -c Release -o /app/build/Nimb3s.Streets.Api.UnitTests
RUN dotnet build "tests/Nimb3s.Streets.Api.ComponentTests/Nimb3s.Streets.Api.ComponentTests.csproj" -c Release -o /app/build/Nimb3s.Streets.Api.ComponentTests
#RUN ls -R

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

####run api
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS final
WORKDIR /app
COPY --from=publish /app/publish/Nimb3s.Streets.Api /app/executables/Nimb3s.Streets.Api
ENTRYPOINT ["dotnet", "executables/Nimb3s.Streets.Api/Nimb3s.Streets.Api.dll"]
#EXPOSE 80
#EXPOSE 443
