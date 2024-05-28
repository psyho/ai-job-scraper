FROM ruby:3.3.1

# Install wget
RUN apt-get install -y wget

# Get Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update
RUN apt-get install -y google-chrome-stable

ENV APP_HOME /app
RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME

# Install dependencies
ADD Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN mkdir -p db
RUN adduser --system --shell /bin/bash --group --home /home/app app && chown -R app:app db
USER app:app

CMD bundle exec ruby bin/run db/jobs.json