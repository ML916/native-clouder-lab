FROM node:16-alpine3.14 as builder

WORKDIR /home/node
ADD . .

RUN yarn install

# Stage 2
FROM node:16-alpine3.14

WORKDIR /home/node
COPY --chown=node:node --from=builder /home/node .

USER node

ENV HOST 0.0.0.0

EXPOSE 8080

CMD ["yarn", "start"]
