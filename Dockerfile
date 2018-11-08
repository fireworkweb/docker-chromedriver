FROM ubuntu:18.04

LABEL MAINTAINER contact@fireworkweb.com

ENV CHROMEDRIVER_PORT 9515
ENV CHROMEDRIVER_URL_BASE ""
ENV CHROMEDRIVER_WHITELISTED_IPS ""
ENV DISPLAY :0

# Install Dependencies
RUN apt-get update && apt-get install -y wget unzip gnupg

# Install Chrome
RUN wget -q -O - "https://dl-ssl.google.com/linux/linux_signing_key.pub" | apt-key add - \
    && echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get -y install google-chrome-stable \
    && ln -fs /usr/bin/google-chrome /usr/local/bin/google-chrome

# Install ChromeDriver
RUN CHROMEDRIVER_VERSION=`wget -q -O - "https://chromedriver.storage.googleapis.com/LATEST_RELEASE"` \
    && wget -q "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" \
    && unzip "chromedriver_linux64.zip" -d "/usr/local/bin" \
    && rm "chromedriver_linux64.zip" \
    && chmod +x "/usr/local/bin/chromedriver"

# Clean Up
RUN apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

CMD [ "chromedriver", "--port=$CHROMEDRIVER_PORT", "--url-base=$CHROMEDRIVER_URL_BASE" "--whitelisted-ips=$CHROMEDRIVER_WHITELISTED_IPS" ]
