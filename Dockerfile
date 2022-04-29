FROM mcr.microsoft.com/dotnet/sdk:6.0.102 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY SS14.Watchdog/*.csproj ./SS14.Watchdog/
COPY SS14.Watchdog.Tests/*.csproj ./SS14.Watchdog.Tests/
RUN dotnet restore -r ubuntu.20.04-x64

# copy everything else and build app
COPY SS14.Watchdog/. ./SS14.Watchdog/
COPY SS14.Watchdog.Tests/. ./SS14.Watchdog.Tests/
#WORKDIR /source/SS14.Watchdog/
RUN dotnet publish -c release -r ubuntu.20.04-x64 -o /app --no-self-contained --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0.4-focal
#FROM mcr.microsoft.com/dotnet/sdk:6.0

WORKDIR /app
COPY --from=build /app ./SS14.Watchdog/bin/Release/net6.0/ubuntu.20.04-x64/publish
RUN mv SS14.Watchdog/bin/Release/net6.0/ubuntu.20.04-x64/publish ./ \
  && rm -rf SS14.Watchdog \
  && mv publish/* ./ \
  && rm -rf publish \
  && rm -rf /app/appsettings.yml

EXPOSE 5000
EXPOSE 1212

VOLUME ["/app/appsettings.yml", "/app/instances"]

ENTRYPOINT ["/app/SS14.Watchdog"]
#ENTRYPOINT ["dotnet", "SS14.Watchdog.dll"]
