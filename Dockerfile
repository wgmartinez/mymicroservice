FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY ["myMicroservice.csproj", "./"]
RUN dotnet restore "./myMicroservice.csproj"

COPY . .
RUN dotnet build "myMicroservice.csproj" -c Release -o /app


FROM build AS publish
RUN dotnet publish "myMicroservice.csproj" -c Release -o /app

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 5000

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "myMicroservice.dll"]
