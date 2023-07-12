# base image
FROM node:16.20.0-bullseye-slim

ARG APP_DIR=/usr/src/bots/social-media-bot

# container dir after creating
WORKDIR ${APP_DIR}

COPY package.json ${APP_DIR}
COPY yarn.lock ${APP_DIR}

RUN yarn install

# bundle app source code inside container
COPY . ${APP_DIR}

ENV NODE_ENV production

# We don't need the standalone Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Install Google Chrome Stable and fonts
# Note: this installs the necessary libs to make the browser work with Puppeteer.
RUN apt-get update && apt-get install gnupg wget -y && \
  wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install google-chrome-stable -y --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*


# RUN yarn install && yarn build &&
RUN yarn build

CMD [ "yarn", "process:start" ]
