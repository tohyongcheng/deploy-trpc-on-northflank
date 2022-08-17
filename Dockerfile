FROM node:16-alpine AS build
WORKDIR /app

COPY package.json package.json
COPY yarn.lock yarn.lock
COPY tsconfig.json tsconfig.json

COPY next.config.js next.config.js
COPY .env .env
COPY src ./src
COPY public ./public
COPY prisma ./prisma
RUN yarn install
RUN yarn build && yarn --production

FROM node:16-alpine
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/public ./public
COPY --from=build /app/.next ./.next
COPY --from=build /app/next.config.js ./next.config.js
COPY --from=build /app/src/server/env.js ./src/server/env.js

EXPOSE 3000
CMD ["node_modules/.bin/next", "start"]
