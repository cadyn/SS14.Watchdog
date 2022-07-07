# final stage/image
FROM mcr.microsoft.com/dotnet/sdk:6.0

# dependencies
RUN apt-get update \
  && apt-get install -y git python3 python-is-python3 \
  && adduser --disabled-password --home /home/container container

USER container
ENV USER=container HOME=/home/container

WORKDIR /home/container
COPY startup.sh /entrypoint.sh

EXPOSE 5000
EXPOSE 1212

CMD ["/bin/bash", "/entrypoint.sh"]
#ENTRYPOINT ["/app/SS14.Watchdog"]
#ENTRYPOINT ["dotnet", "SS14.Watchdog.dll"]
