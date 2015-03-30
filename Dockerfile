FROM ruby:2.1.5
MAINTAINER Jim Terhorst <jterhorst@itriagehealth.com>

# Clean up the container:
RUN apt-get autoremove -y

# Get package db up to date
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y apt-utils


# Ensure UTF-8
RUN apt-get -y install locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

#Install Nokogiri dependencies
RUN apt-get install -y libxml2 libxml2-dev libxslt1-dev

#Install PhantomJS dependencies
RUN apt-get install -y wget libfontconfig1-dev libssl-dev

#Install Postgresql dependencies
RUN apt-get install -y postgresql-client

#Install NodeJS Setup with Debian, copied from https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get -y install nodejs

#Install PhantomJS
RUN wget -q https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2
RUN tar xjf phantomjs-1.9.7-linux-x86_64.tar.bz2
RUN install -t /usr/local/bin phantomjs-1.9.7-linux-x86_64/bin/phantomjs
RUN rm -rf phantomjs-1.9.7-linux-x86_64
RUN rm phantomjs-1.9.7-linux-x86_64.tar.bz2

# Create app folder:
RUN mkdir /app
WORKDIR /app

# Install Dependencies:
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install



# Add the app app:
COPY . /app

RUN cp /app/config/application.docker.yml /app/config/application.yml
RUN cp /app/config/settings.docker.yml settings.yml
# Expose the port
ENV PORT 80
EXPOSE 80
ENV HOME /app

CMD ["rails", "server", "--binding=0.0.0.0", "--port=80"]