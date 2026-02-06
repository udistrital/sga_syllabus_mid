# Build stage for installing libmcrypt
FROM debian:12 as builder

RUN apt-get update && \
    apt-get install -y libmcrypt4 libmcrypt-dev && \
    rm -rf /var/lib/apt/lists/*

# Final stage with distroless
FROM gcr.io/distroless/base-debian12

COPY --from=builder /usr/lib/x86_64-linux-gnu/libmcrypt.so* /usr/lib/x86_64-linux-gnu/

COPY main main
COPY conf/app.conf conf/app.conf
ENV API_NAME=syllabus_mid
ENV SERVICE_NAME=syllabusmid
ENV API_BASE_DIR=github.com/udistrital
ENV SYLLABUS_MID_HTTP_PORT=8095
ENV SYLLABUS_MID_RUNMODE=dev
ENV PARAMETER_STORE=

ENV ACADEMICA_ESPACIO_ACADEMICO_SERVICE=busservicios.intranetoas.udistrital.edu.co:8282/wso2eiserver/services/academica_pruebas/
ENV IDIOMA_SERVICE=pruebasapi.intranetoas.udistrital.edu.co:8098/v1/
ENV HOMOLOGACION_DEPENDENCIA_SERVICE=busservicios.intranetoas.udistrital.edu.co:8282/wso2eiserver/services/servicios_homologacion_dependencias/
ENV OIKOS_SERVICE=pruebasapi.intranetoas.udistrital.edu.co:8087/v2/
ENV SYLLABUS_SERVICE=d1bpmwg4t8.execute-api.us-east-1.amazonaws.com/Prod/


ENTRYPOINT ["/main"]