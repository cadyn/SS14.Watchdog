FROM mcr.microsoft.com/dotnet/core/sdk:6.0 AS build

# copy csproj and restore as distinct layers
COPY *.sln .
COPY SS14.Watchdog/*.csproj ./SS14.Watchdog/
RUN dotnet restore

# copy everything else and build app
COPY SS14.Watchdog/. ./SS14.Watchdog/
WORKDIR /source/SS14.Watchdog/
RUN dotnet publish -c release -r linux-x64 -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "SS14.Watchdog.dll"]
