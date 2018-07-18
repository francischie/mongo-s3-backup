FROM mongo:3.4.10
COPY *.sh script/
RUN apt-get update \
	&& apt-get install -y python-pip cron \	
    && rm -rf /var/lib/apt/lists/*
RUN pip install awscli
