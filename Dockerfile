FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY SS14.Watchdog/*.csproj ./SS14.Watchdog/
COPY SS14.Watchdog.Tests/*.csproj ./SS14.Watchdog.Tests/
RUN dotnet restore -r linux-x64

# copy everything else and build app
COPY SS14.Watchdog/. ./SS14.Watchdog/
COPY SS14.Watchdog.Tests/. ./SS14.Watchdog.Tests/
#WORKDIR /source/SS14.Watchdog/
RUN dotnet publish -c release -r linux-x64 -o /app --no-self-contained --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./SS14.Watchdog/bin/Release/net6.0/linux-x64/publish
RUN rm -rf /app/appsettings.yml

EXPOSE 5000
EXPOSE 1212

VOLUME ["/app/appsettings.yml", "/app/instances"]

ENTRYPOINT ["dotnet", "SS14.Watchdog.dll"]
