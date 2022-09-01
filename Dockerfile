FROM alpine:3.16.2 as installer
RUN apk update && \
    apk add --no-cache ansible-core sshpass openssh

FROM scratch 
COPY --from=installer / /
