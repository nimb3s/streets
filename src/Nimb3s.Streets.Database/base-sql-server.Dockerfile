FROM mcr.microsoft.com/mssql/server:2019-latest 
# Elevate to root to install required packages
USER root
RUN apt-get update \
    && apt-get install unzip libunwind8 libicu60 libssl1.0 -y

# Install SQLPackage for Linux and make it executable
RUN wget -progress=bar:force -q -O sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2113331 \
    && unzip -qq sqlpackage.zip -d /opt/sqlpackage \
    && chmod +x /opt/sqlpackage/sqlpackage \
    && chown -R mssql /opt/sqlpackage \
    && mkdir /tmp/db \
    && chown -R mssql /tmp/db

#docker build -f "C:\git\streets\src\Nimb3s.Streets.Database\base-sq-server.Dockerfile" -t nimb3s/base-sql-server:2019-latest --force-rm "C:\git\streets" --progress plain --no-cache
#docker push nimb3s/base-sql-server:2019-latest