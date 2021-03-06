FROM resin/rpi-raspbian

MAINTAINER F.-X. Martin mail@fxmartin.me

# Install Apache, apcupsd et apcupsd-cgi
RUN apt-get update && apt-get install -y apache2 \
	apcupsd \
	apcupsd-cgi && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Define ServerName for Apache
RUN echo 'ServerName apcupsd' >> /etc/apache2/apache2.conf

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Set correct user and group rights
RUN chown -R www-data:www-data /usr/lib/cgi-bin && \
	sudo chmod -R g+rw /usr/lib/cgi-bin && \
	sudo chown -R www-data:www-data /var/www && \
	sudo chmod -R g+rw /var/www

# Enable apache mods.
RUN a2enmod cgi

# Expose ports
EXPOSE 80 443

# Copy the config items
COPY ./config/init.sh /init.sh
COPY ./config/index.html /var/www/html/index.html

# Define default command
CMD ["/init.sh"]
