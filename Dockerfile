# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY tagincrementpoc/*.csproj ./tagincrementpoc/
RUN dotnet restore

# copy everything else and build app
COPY tagincrementpoc/. ./tagincrementpoc/
WORKDIR /source/tagincrementpoc
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "tagincrementpoc.dll"]
