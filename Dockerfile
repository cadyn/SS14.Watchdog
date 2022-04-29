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

#dependencies
RUN apt-get update \
  && apt-get install -y apt-transport-https dirmngr gnupg ca-certificates \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && echo "deb https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
  && apt-get update \
  && apt-get install -y mono-complete

WORKDIR /app
COPY --from=build /app ./SS14.Watchdog/bin/Release/net6.0/linux-x64/publish
RUN mv SS14.Watchdog/bin/Release/net6.0/linux-x64/publish ./ \
  && rm -rf SS14.Watchdog \
  && mv publish/* ./ \
  && rm -rf publish \
  && rm -rf /app/appsettings.yml

EXPOSE 5000
EXPOSE 1212

VOLUME ["/app/appsettings.yml", "/app/instances"]

ENTRYPOINT ["/app/SS14.Watchdog"]
#ENTRYPOINT ["dotnet", "SS14.Watchdog.dll"]
