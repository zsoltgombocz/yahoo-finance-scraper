FROM node:18

RUN apt-get update

RUN apt-get install -yyq ca-certificates

RUN apt-get install -yyq libappindicator1 libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6

RUN apt-get install -yyq gconf-service lsb-release wget xdg-utils

RUN apt-get install -yyq fonts-liberation

RUN apt-get install -yyq cron

RUN apt-get install -yyq supervisor

RUN apt-get install -yyq nano

RUN echo "0 0 18 * * /etc/cron.d/send-to-discord >> /var/log/send-to-discord.log 2>&1"

WORKDIR /app
COPY package*.json .

RUN npm ci
RUN npm install typescript -g

COPY . .

RUN mv ./send-to-discord.sh /usr/local/sbin/send-to-discord
RUN chmod +x /usr/local/sbin/send-to-discord

RUN echo "59 23 20 * * root /usr/local/sbin/send-to-discord >> /var/log/send-to-discord.log 2>&1" >> /etc/cron.d/send-to-discord-cron 

RUN chmod 0644 /etc/cron.d/send-to-discord-cron

RUN npm run tsc

CMD ["supervisord", "-c", "/app/supervisord.conf"]
#CMD ["npm", "run", "start:prod"]